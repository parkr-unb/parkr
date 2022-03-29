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


/** This is an auto generated class representing the GeoCoord type in your schema. */
@immutable
class GeoCoord {
  final double? _latitude;
  final double? _longitude;

  double get latitude {
    try {
      return _latitude!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get longitude {
    try {
      return _longitude!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const GeoCoord._internal({required latitude, required longitude}): _latitude = latitude, _longitude = longitude;
  
  factory GeoCoord({required double latitude, required double longitude}) {
    return GeoCoord._internal(
      latitude: latitude,
      longitude: longitude);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoCoord &&
      _latitude == other._latitude &&
      _longitude == other._longitude;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("GeoCoord {");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  GeoCoord copyWith({double? latitude, double? longitude}) {
    return GeoCoord._internal(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude);
  }
  
  GeoCoord.fromJson(Map<String, dynamic> json)  
    : _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'latitude': _latitude, 'longitude': _longitude
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GeoCoord";
    modelSchemaDefinition.pluralName = "GeoCoords";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'latitude',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'longitude',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
  });
}