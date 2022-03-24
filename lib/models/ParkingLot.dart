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


/** This is an auto generated class representing the ParkingLot type in your schema. */
@immutable
class ParkingLot {
  final String? _name;
  final List<GeoCoord>? _coords;

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
  
  List<GeoCoord> get coords {
    try {
      return _coords!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const ParkingLot._internal({required name, required coords}): _name = name, _coords = coords;
  
  factory ParkingLot({required String name, required List<GeoCoord> coords}) {
    return ParkingLot._internal(
      name: name,
      coords: coords != null ? List<GeoCoord>.unmodifiable(coords) : coords);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParkingLot &&
      _name == other._name &&
      DeepCollectionEquality().equals(_coords, other._coords);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ParkingLot {");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("coords=" + (_coords != null ? _coords!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ParkingLot copyWith({String? name, List<GeoCoord>? coords}) {
    return ParkingLot._internal(
      name: name ?? this.name,
      coords: coords ?? this.coords);
  }
  
  ParkingLot.fromJson(Map<String, dynamic> json)  
    : _name = json['name'],
      _coords = json['coords'] is List
        ? (json['coords'] as List)
          .where((e) => e != null)
          .map((e) => GeoCoord.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'name': _name, 'coords': _coords?.map((GeoCoord? e) => e?.toJson()).toList()
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ParkingLot";
    modelSchemaDefinition.pluralName = "ParkingLots";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'name',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.embedded(
      fieldName: 'coords',
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'GeoCoord')
    ));
  });
}