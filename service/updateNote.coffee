Evernote = require('evernote').Evernote

updateNote (noteStore, guid, title, content, options) ->
  nBody = '<?xml version="1.0" encoding="UTF-8"?>'
  nBody += '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'
  nBody += '<en-note>' + noteBody + '</en-note>'

  note = new (Evernote.Note)
  note.guid = guid
  note.title = title
  note.content = content

  if options
    attr = new Evernote.NoteAttributes
    if options.notebookGuid
      ourNote.notebookGuid = options.notebookGuid
    if options.tagNames
      ourNote.tagNames = options.tagNames
    if options.sourceURL
      attr.sourceURL = options.sourceURL


