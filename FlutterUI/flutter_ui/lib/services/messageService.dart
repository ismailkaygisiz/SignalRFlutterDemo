import 'package:flutter_ui/core/models/deleteModel.dart';
import 'package:flutter_ui/core/models/response/listResponseModel.dart';
import 'package:flutter_ui/core/models/response/responseModel.dart';
import 'package:flutter_ui/core/models/response/singleResponseModel.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/core/utilities/serviceRepository.dart';
import 'package:flutter_ui/environments/api.dart';
import 'package:flutter_ui/models/messageAddModel.dart';
import 'package:flutter_ui/models/messageModel.dart';

class MessageService
    implements ServiceRepository<MessageAddModel, MessageModel> {
  @override
  Future<ResponseModel> add(MessageAddModel addModel) async {
    var response = await httpClient.post(
      Uri.parse(API_URL + "messages/add"),
      body: addModel,
    );

    return ResponseModel.fromJson(response);
  }

  @override
  Future<ResponseModel> delete(DeleteModel deleteModel) async {
    var response = await httpClient.post(
      Uri.parse(API_URL + "messages/delete"),
      body: deleteModel,
    );

    return ResponseModel.fromJson(response);
  }

  @override
  Future<ListResponseModel<MessageModel>> getAll() async {
    var response = await httpClient.get(
      Uri.parse(API_URL + "messages/getall"),
    );

    return ListResponseModel<MessageModel>.fromJson(response);
  }

  @override
  Future<SingleResponseModel<MessageModel>> getById(int id) async {
    var response = await httpClient.get(
      Uri.parse(API_URL + "messages/getbyid?id=" + id.toString()),
    );

    return SingleResponseModel<MessageModel>.fromJson(response);
  }

  Future<ListResponseModel<MessageModel>> getByUserId(int userId) async {
    var response = await httpClient.get(
      Uri.parse(API_URL + "messages/getbyuserid?userId=" + userId.toString()),
    );

    return ListResponseModel<MessageModel>.fromJson(response);
  }

  Future<ListResponseModel<MessageModel>> getByUserAndReceiver(
      int userId, int receiverId) async {
    var response = await httpClient.get(
      Uri.parse(
        API_URL +
            "messages/getbyuserandreceiver?userId=" +
            userId.toString() +
            "&receiverId=" +
            receiverId.toString(),
      ),
    );

    return ListResponseModel<MessageModel>.fromJson(response);
  }

  @override
  Future<ResponseModel> update(MessageModel updateModel) async {
    var response = await httpClient.post(
      Uri.parse(API_URL + "messages/update"),
      body: updateModel,
    );

    return ResponseModel.fromJson(response);
  }
}
