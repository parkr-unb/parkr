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

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the ParkingPermits type in your schema. */
@immutable
class ParkingPermits extends Model {
  static const classType = const _ParkingPermitsModelType();
  final String id;
  final List<ParkingPermit>? _permits;
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
  
  List<ParkingPermit>? get permits {
    return _permits;
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
  
  const ParkingPermits._internal({required this.id, permits, required firstName, required lastName, required emailAddress, createdAt, updatedAt}): _permits = permits, _firstName = firstName, _lastName = lastName, _emailAddress = emailAddress, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ParkingPermits({String? id, List<ParkingPermit>? permits, required String firstName, required String lastName, required String emailAddress}) {
    return ParkingPermits._internal(
      id: id == null ? UUID.getUUID() : id,
      permits: permits != null ? List<ParkingPermit>.unmodifiable(permits) : permits,
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
    return other is ParkingPermits &&
      id == other.id &&
      DeepCollectionEquality().equals(_permits, other._permits) &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _emailAddress == other._emailAddress;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ParkingPermits {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("permits=" + (_permits != null ? _permits!.toString() : "null") + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("emailAddress=" + "$_emailAddress" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ParkingPermits copyWith({String? id, List<ParkingPermit>? permits, String? firstName, String? lastName, String? emailAddress}) {
    return ParkingPermits._internal(
      id: id ?? this.id,
      permits: permits ?? this.permits,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress);
  }
  
  ParkingPermits.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _permits = json['permits'] is List
        ? (json['permits'] as List)
          .where((e) => e != null)
          .map((e) => ParkingPermit.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _emailAddress = json['emailAddress'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'permits': _permits?.map((ParkingPermit? e) => e?.toJson()).toList(), 'firstName': _firstName, 'lastName': _lastName, 'emailAddress': _emailAddress, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "parkingPermits.id");
  static final QueryField PERMITS = QueryField(fieldName: "permits");
  static final QueryField FIRSTNAME = QueryField(fieldName: "firstName");
  static final QueryField LASTNAME = QueryField(fieldName: "lastName");
  static final QueryField EMAILADDRESS = QueryField(fieldName: "emailAddress");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ParkingPermits";
    modelSchemaDefinition.pluralName = "ParkingPermits";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'permits',
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'ParkingPermit')
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermits.FIRSTNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermits.LASTNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ParkingPermits.EMAILADDRESS,
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

class _ParkingPermitsModelType extends ModelType<ParkingPermits> {
  const _ParkingPermitsModelType();
  
  @override
  ParkingPermits fromJson(Map<String, dynamic> jsonData) {
    return ParkingPermits.fromJson(jsonData);
  }
}