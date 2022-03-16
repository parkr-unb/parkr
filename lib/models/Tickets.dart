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


/** This is an auto generated class representing the Tickets type in your schema. */
@immutable
class Tickets extends Model {
  static const classType = const _TicketsModelType();
  final String id;
  final List<Ticket>? _tickets;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  List<Ticket>? get tickets {
    return _tickets;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Tickets._internal({required this.id, tickets, createdAt, updatedAt}): _tickets = tickets, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Tickets({String? id, List<Ticket>? tickets}) {
    return Tickets._internal(
      id: id == null ? UUID.getUUID() : id,
      tickets: tickets != null ? List<Ticket>.unmodifiable(tickets) : tickets);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tickets &&
      id == other.id &&
      DeepCollectionEquality().equals(_tickets, other._tickets);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Tickets {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tickets=" + (_tickets != null ? _tickets!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Tickets copyWith({String? id, List<Ticket>? tickets}) {
    return Tickets._internal(
      id: id ?? this.id,
      tickets: tickets ?? this.tickets);
  }
  
  Tickets.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tickets = json['tickets'] is List
        ? (json['tickets'] as List)
          .where((e) => e != null)
          .map((e) => Ticket.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tickets': _tickets?.map((Ticket? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "tickets.id");
  static final QueryField TICKETS = QueryField(fieldName: "tickets");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Tickets";
    modelSchemaDefinition.pluralName = "Tickets";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'tickets',
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Ticket')
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

class _TicketsModelType extends ModelType<Tickets> {
  const _TicketsModelType();
  
  @override
  Tickets fromJson(Map<String, dynamic> jsonData) {
    return Tickets.fromJson(jsonData);
  }
}