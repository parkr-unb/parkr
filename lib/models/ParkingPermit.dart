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
class ParkingPermit {
  final TemporalDateTime? _termStart;
  final TemporalDateTime? _termEnd;
  final String? _passType;

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
  
  const ParkingPermit._internal({required termStart, required termEnd, required passType}): _termStart = termStart, _termEnd = termEnd, _passType = passType;
  
  factory ParkingPermit({required TemporalDateTime termStart, required TemporalDateTime termEnd, required String passType}) {
    return ParkingPermit._internal(
      termStart: termStart,
      termEnd: termEnd,
      passType: passType);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParkingPermit &&
      _termStart == other._termStart &&
      _termEnd == other._termEnd &&
      _passType == other._passType;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ParkingPermit {");
    buffer.write("termStart=" + (_termStart != null ? _termStart!.format() : "null") + ", ");
    buffer.write("termEnd=" + (_termEnd != null ? _termEnd!.format() : "null") + ", ");
    buffer.write("passType=" + "$_passType");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ParkingPermit copyWith({TemporalDateTime? termStart, TemporalDateTime? termEnd, String? passType}) {
    return ParkingPermit._internal(
      termStart: termStart ?? this.termStart,
      termEnd: termEnd ?? this.termEnd,
      passType: passType ?? this.passType);
  }
  
  ParkingPermit.fromJson(Map<String, dynamic> json)  
    : _termStart = json['termStart'] != null ? TemporalDateTime.fromString(json['termStart']) : null,
      _termEnd = json['termEnd'] != null ? TemporalDateTime.fromString(json['termEnd']) : null,
      _passType = json['passType'];
  
  Map<String, dynamic> toJson() => {
    'termStart': _termStart?.format(), 'termEnd': _termEnd?.format(), 'passType': _passType
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ParkingPermit";
    modelSchemaDefinition.pluralName = "ParkingPermits";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'termStart',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'termEnd',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'passType',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}