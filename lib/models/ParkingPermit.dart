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


/** This is an auto generated class representing the ParkingPermit type in your schema. */
@immutable
class ParkingPermit extends Model {
  static const classType = const _ParkingPermitModelType();
  final String id;
  final TemporalDateTime? _termStart;
  final TemporalDateTime? _termEnd;
  final String? _passType;
  final String? _firstName;
  final String? _lastName;
  final String? _emailAddress;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  TemporalDateTime get termStart {
    try {
      return _termStart!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get termEnd {
    try {
      return _termEnd!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get passType {
    try {
      return _passType!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get firstName {
    try {
      return _firstName!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get lastName {
    try {
      return _lastName!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get emailAddress {
    try {
      return _emailAddress!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ParkingPermit._internal({required this.id, required termStart, required termEnd, required passType, required firstName, required lastName, required emailAddress, createdAt, updatedAt}): _termStart = termStart, _termEnd = termEnd, _passType = passType, _firstName = firstName, _lastName = lastName, _emailAddress = emailAddress, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ParkingPermit({String? id, required TemporalDateTime termStart, required TemporalDateTime termEnd, required String passType, required String firstName, required String lastName, required String emailAddress}) {
    return ParkingPermit._internal(
      id: id == null ? UUID.getUUID() : id,
      termStart: termStart,
      termEnd: termEnd,
      passType: passType,
      firstName: firstName,
      lastName: lastName,
      emailAddress: emailAddress);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParkingPermit &&
      id == other.id &&
      _termStart == other._termStart &&
      _termEnd == other._termEnd &&
      _passType == other._passType &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _emailAddress == other._emailAddress;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ParkingPermit {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("termStart=" + (_termStart != null ? _termStart!.format() : "null") + ", ");
    buffer.write("termEnd=" + (_termEnd != null ? _termEnd!.format() : "null") + ", ");
    buffer.write("passType=" + "$_passType" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("emailAddress=" + "$_emailAddress" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ParkingPermit copyWith({String? id, TemporalDateTime? termStart, TemporalDateTime? termEnd, String? passType, String? firstName, String? lastName, String? emailAddress}) {
    return ParkingPermit._internal(
      id: id ?? this.id,
      termStart: termStart ?? this.termStart,
      termEnd: termEnd ?? this.termEnd,
      passType: passType ?? this.passType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress);
  }
  
  ParkingPermit.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _termStart = json['termStart'] != null ? TemporalDateTime.fromString(json['termStart']) : null,
      _termEnd = json['termEnd'] != null ? TemporalDateTime.fromString(json['termEnd']) : null,
      _passType = json['passType'],
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _emailAddress = json['emailAddress'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'termStart': _termStart?.format(), 'termEnd': _termEnd?.format(), 'passType': _passType, 'firstName': _firstName, 'lastName': _lastName, 'emailAddress': _emailAddress, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "parkingPermit.id");
  static final QueryField TERMSTART = QueryField(fieldName: "termStart");
  static final QueryField TERMEND = QueryField(fieldName: "termEnd");
  static final QueryField PASSTYPE = QueryField(fieldName: "passType");
  static final QueryField FIRSTNAME = QueryField(fieldName: "firstName");
  static final QueryField LASTNAME = QueryField(fieldName: "lastName");
  static final QueryField EMAILADDRESS = QueryField(fieldName: "emailAddress");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ParkingPermit";
    modelSchemaDefinition.pluralName = "ParkingPermits";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.TERMSTART,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.TERMEND,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.PASSTYPE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.FIRSTNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.LASTNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermit.EMAILADDRESS,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ParkingPermitModelType extends ModelType<ParkingPermit> {
  const _ParkingPermitModelType();
  
  @override
  ParkingPermit fromJson(Map<String, dynamic> jsonData) {
    return ParkingPermit.fromJson(jsonData);
  }
}