import 'package:flutter/material.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'package:flutternotes/services/crud/notes_service.dart';
import 'package:flutternotes/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NotesService();
    super.initState();
  }

//since we are dealing with a singleton class that will be opne the entire time, its best we donot close the db on any widgets
  /* @override
  void dispose() {
    _noteService.close();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }

              ;
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: MenuAction.logout, child: Text('logout'))
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _noteService.allNotes,
                  builder: ((context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return NoteListView(
                            notes: allNotes,
                            onDeleteNote: (note) async {
                              await _noteService.deleteNote(id: note.id);
                            },
                            onTap: (note) {
                              Navigator.of(context).pushNamed(
                                  createOrUpdateRoute,
                                  arguments: note);
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }

                      default:
                        return const CircularProgressIndicator();
                    }
                  }));
            default:
              return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
