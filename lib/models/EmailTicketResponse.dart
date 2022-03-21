/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the EmailTicketResponse type in your schema. */
@immutable
class EmailTicketResponse {
  final String? _messageId;
  final String? _message;
  final String? _error;

  String? get messageId {
    return _messageId;
  }
  
  String? get message {
    return _message;
  }
  
  String? get error {
    return _error;
  }
  
  const EmailTicketResponse._internal({messageId, message, error}): _messageId = messageId, _message = message, _error = error;
  
  factory EmailTicketResponse({String? messageId, String? message, String? error}) {
    return EmailTicketResponse._internal(
      messageId: messageId,
      message: message,
      error: error);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailTicketResponse &&
      _messageId == other._messageId &&
      _message == other._message &&
      _error == other._error;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("EmailTicketResponse {");
    buffer.write("messageId=" + "$_messageId" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("error=" + "$_error");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  EmailTicketResponse copyWith({String? messageId, String? message, String? error}) {
    return EmailTicketResponse._internal(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      error: error ?? this.error);
  }
  
  EmailTicketResponse.fromJson(Map<String, dynamic> json)  
    : _messageId = json['messageId'],
      _message = json['message'],
      _error = json['error'];
  
  Map<String, dynamic> toJson() => {
    'messageId': _messageId, 'message': _message, 'error': _error
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "EmailTicketResponse";
    modelSchemaDefinition.pluralName = "EmailTicketResponses";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'messageId',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'message',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'error',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}