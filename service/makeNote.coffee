Evernote = require('evernote').Evernote


makeNote = (noteStore, noteTitle, noteBody, parentNotebook, callback) ->
  nBody = '<?xml version="1.0" encoding="UTF-8"?>'
  nBody += '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'
  nBody += '<en-note>' + noteBody + '</en-note>'
  # Create note object
  ourNote = new (Evernote.Note)
  ourNote.title = noteTitle
  ourNote.content = nBody
  if parentNotebook
    ourNote.notebookGuid = parentNotebook
  # Attempt to create note in Evernote account
  noteStore.createNote ourNote, (err, note) ->
    if err
# Something was wrong with the note data
# See EDAMErrorCode enumeration for error code explanation
# http://dev.evernote.com/documentation/reference/Errors.html#Enum_EDAMErrorCode
      console.log callback(err)
    else
      callback null, note
    return
  return


module.exports = makeNote