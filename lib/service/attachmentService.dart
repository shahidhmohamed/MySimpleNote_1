import 'package:MySimpleNotes/model/Attachment.dart';
import 'package:MySimpleNotes/repository/attachmentRepository.dart';

class AttachmentServices{
  late AttachmentRepository _attachmentRepository;

  AttachmentServices(){
    _attachmentRepository = AttachmentRepository();
  }

  saveNote(Attachment attachment) async{
    return await _attachmentRepository.insertData('attachments', attachment.attachmentMap());
  }

  readAllAttachments() async{
    return await _attachmentRepository.readData('attachments');
  }

  deleteAttachment(Id) async{
    return await _attachmentRepository.deleteDataById('attachments',Id);
  }

}