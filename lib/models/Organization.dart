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


/** This is an auto generated class representing the Organization type in your schema. */
@immutable
class Organization extends Model {
  static const classType = const _OrganizationModelType();
  final String id;
  final List<String>? _domainAllow;
  final List<Officer>? _officers;
  List<ParkingLot>? _parkingLots;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  List<String>? get domainAllow {
    return _domainAllow;
  }
  
  List<Officer>? get officers {
    return _officers;
  }

  List<ParkingLot>? get parkingLots {
    return _parkingLots;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  set parkingLots(List<ParkingLot>? lot) {
    _parkingLots = lot;
  }
  
  Organization._internal({required this.id, domainAllow, officers, parkingLots, createdAt, updatedAt}): _domainAllow = domainAllow, _officers = officers, _parkingLots = parkingLots, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Organization({String? id, List<String>? domainAllow, List<Officer>? officers, List<ParkingLot>? parkingLots}) {
    return Organization._internal(
      id: id == null ? UUID.getUUID() : id,
      domainAllow: domainAllow != null ? List<String>.unmodifiable(domainAllow) : domainAllow,
      officers: officers != null ? List<Officer>.unmodifiable(officers) : officers,
      parkingLots: parkingLots != null ? List<ParkingLot>.unmodifiable(parkingLots) : parkingLots);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Organization &&
      id == other.id &&
      DeepCollectionEquality().equals(_domainAllow, other._domainAllow) &&
      DeepCollectionEquality().equals(_officers, other._officers) &&
      DeepCollectionEquality().equals(_parkingLots, other._parkingLots);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Organization {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("domainAllow=" + (_domainAllow != null ? _domainAllow!.toString() : "null") + ", ");
    buffer.write("parkingLots=" + (_parkingLots != null ? _parkingLots!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Organization copyWith({String? id, List<String>? domainAllow, List<Officer>? officers, List<ParkingLot>? parkingLots}) {
    return Organization._internal(
      id: id ?? this.id,
      domainAllow: domainAllow ?? this.domainAllow,
      officers: officers ?? this.officers,
      parkingLots: parkingLots ?? this.parkingLots);
  }
  
  Organization.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _domainAllow = json['domainAllow']?.cast<String>(),
      _officers = json['officers'] is List
        ? (json['officers'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Officer.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _parkingLots = json['parkingLots'] is List
        ? (json['parkingLots'] as List)
          .where((e) => e != null)
          .map((e) => ParkingLot.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'domainAllow': _domainAllow, 'officers': _officers?.map((Officer? e) => e?.toJson()).toList(), 'parkingLots': _parkingLots?.map((ParkingLot? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "organization.id");
  static final QueryField DOMAINALLOW = QueryField(fieldName: "domainAllow");
  static final QueryField OFFICERS = QueryField(
    fieldName: "officers",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Officer).toString()));
  static final QueryField PARKINGLOTS = QueryField(fieldName: "parkingLots");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Organization";
    modelSchemaDefinition.pluralName = "Organizations";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Organization.DOMAINALLOW,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Organization.OFFICERS,
      isRequired: true,
      ofModelName: (Officer).toString(),
      associatedKey: Officer.ORGANIZATION
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'parkingLots',
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'ParkingLot')
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

class _OrganizationModelType extends ModelType<Organization> {
  const _OrganizationModelType();
  
  @override
  Organization fromJson(Map<String, dynamic> jsonData) {
    return Organization.fromJson(jsonData);
  }
}