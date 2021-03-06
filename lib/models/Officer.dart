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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Officer type in your schema. */
@immutable
class Officer extends Model {
  static const classType = const _OfficerModelType();
  final String id;
  final String? _role;
  final String? _name;
  final Organization? _organization;
  final bool? _confirmed;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get role {
    try {
      return _role!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Organization? get organization {
    return _organization;
  }
  
  bool? get confirmed {
    return _confirmed;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Officer._internal({required this.id, required role, required name, organization, confirmed, createdAt, updatedAt}): _role = role, _name = name, _organization = organization, _confirmed = confirmed, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Officer({String? id, required String role, required String name, Organization? organization, bool? confirmed}) {
    return Officer._internal(
      id: id == null ? UUID.getUUID() : id,
      role: role,
      name: name,
      organization: organization,
      confirmed: confirmed);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Officer &&
      id == other.id &&
      _role == other._role &&
      _name == other._name &&
      _organization == other._organization &&
      _confirmed == other._confirmed;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Officer {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("role=" + "$_role" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("organization=" + (_organization != null ? _organization!.toString() : "null") + ", ");
    buffer.write("confirmed=" + (_confirmed != null ? _confirmed!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Officer copyWith({String? id, String? role, String? name, Organization? organization, bool? confirmed}) {
    return Officer._internal(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      confirmed: confirmed ?? this.confirmed);
  }
  
  Officer.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _role = json['role'],
      _name = json['name'],
      _organization = json['organization']?['serializedData'] != null
        ? Organization.fromJson(new Map<String, dynamic>.from(json['organization']['serializedData']))
        : null,
      _confirmed = json['confirmed'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'role': _role, 'name': _name, 'organization': _organization?.toJson(), 'confirmed': _confirmed, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "officer.id");
  static final QueryField ROLE = QueryField(fieldName: "role");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField ORGANIZATION = QueryField(
    fieldName: "organization",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Organization).toString()));
  static final QueryField CONFIRMED = QueryField(fieldName: "confirmed");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Officer";
    modelSchemaDefinition.pluralName = "Officers";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Officer.ROLE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Officer.NAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
      key: Officer.ORGANIZATION,
      isRequired: false,
      targetName: "organizationOfficersId",
      ofModelName: (Organization).toString()
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Officer.CONFIRMED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
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

class _OfficerModelType extends ModelType<Officer> {
  const _OfficerModelType();
  
  @override
  Officer fromJson(Map<String, dynamic> jsonData) {
    return Officer.fromJson(jsonData);
  }
}