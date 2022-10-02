import 'package:flutter/material.dart';
import 'package:flutternotes/services/crud/notes_service.dart';
import 'package:flutternotes/utilities/generics/get_arguments.dart';

import '../../services/auth/auth_service.dart';

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void initState() {
    //will not create the instance if it is already existing since its a singleton
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

//update the Note in the db everytime we type sth in the text editor
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setUpTextControllerlistener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('NewNote')),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                //_note = snapshot.data as DatabaseNote;
                _setUpTextControllerlistener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Satrt typing your note...',
                  ),
                );

              default:
                return const CircularProgressIndicator();
            }
          }),
        ));
  }
}
