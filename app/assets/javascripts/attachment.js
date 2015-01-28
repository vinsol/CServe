function Attachment(attachmentdiv, button) {
  this.div       = attachmentdiv;
  this.addButton = button;
  this.count     = 1;
};

Attachment.prototype.init = function () {
  this.bindEvents();
};

Attachment.prototype.bindEvents = function () {
  var _this = this;
  this.addButton.on('click', function() {
    _this.addAttachmentField(_this);
  })
};

Attachment.prototype.addAttachmentField = function (attachment) {
  count = attachment.count++
  var $attachmentDiv = $('<div/>', {
    'class': 'col-sm-8 attachment',
  });

  var $attachmentField = $('<input/>', {
    id: 'ticket_attachments_attributes_' + count + '_document',
    name: 'ticket[attachments_attributes][][document]',
    'class': 'attachments',
    type: 'file'
  });

  var $removeButton = $('<button/>', {
    'class': 'close remove',
    'data-dismiss': 'alert'
  }).html('×');
  console.log($removeButton)

  $attachmentDiv.append($attachmentField, $removeButton);
  attachment.div.append($attachmentDiv);
};

$(document).ready(function () {
  var attachment = new Attachment($('#attachment-container'), $('#add'));
  attachment.init();
});