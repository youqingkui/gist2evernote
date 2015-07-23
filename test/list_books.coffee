noteStore = require('../service/noteStroe')


noteStore.listNotebooks (err, books) ->
  return console.log err if err
  console.log books