// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.36.5
// 	protoc        v4.23.4
// source: protos/accessibility.proto

package proto

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	emptypb "google.golang.org/protobuf/types/known/emptypb"
	wrapperspb "google.golang.org/protobuf/types/known/wrapperspb"
	reflect "reflect"
	unsafe "unsafe"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

var File_protos_accessibility_proto protoreflect.FileDescriptor

var file_protos_accessibility_proto_rawDesc = string([]byte{
	0x0a, 0x1a, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x73, 0x2f, 0x61, 0x63, 0x63, 0x65, 0x73, 0x73, 0x69,
	0x62, 0x69, 0x6c, 0x69, 0x74, 0x79, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x0d, 0x61, 0x63,
	0x63, 0x65, 0x73, 0x73, 0x69, 0x62, 0x69, 0x6c, 0x69, 0x74, 0x79, 0x1a, 0x1b, 0x67, 0x6f, 0x6f,
	0x67, 0x6c, 0x65, 0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2f, 0x65, 0x6d, 0x70,
	0x74, 0x79, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x1a, 0x1e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2f, 0x77, 0x72, 0x61, 0x70, 0x70, 0x65,
	0x72, 0x73, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x32, 0xfc, 0x10, 0x0a, 0x14, 0x41, 0x63, 0x63,
	0x65, 0x73, 0x73, 0x69, 0x62, 0x69, 0x6c, 0x69, 0x74, 0x79, 0x53, 0x65, 0x72, 0x76, 0x69, 0x63,
	0x65, 0x12, 0x47, 0x0a, 0x0f, 0x47, 0x65, 0x74, 0x48, 0x69, 0x67, 0x68, 0x43, 0x6f, 0x6e, 0x74,
	0x72, 0x61, 0x73, 0x74, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67,
	0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42,
	0x6f, 0x6f, 0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x46, 0x0a, 0x12, 0x45, 0x6e,
	0x61, 0x62, 0x6c, 0x65, 0x48, 0x69, 0x67, 0x68, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x61, 0x73, 0x74,
	0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x22, 0x00, 0x12, 0x47, 0x0a, 0x13, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x48, 0x69, 0x67,
	0x68, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x61, 0x73, 0x74, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74,
	0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x48, 0x0a, 0x10, 0x47,
	0x65, 0x74, 0x52, 0x65, 0x64, 0x75, 0x63, 0x65, 0x64, 0x4d, 0x6f, 0x74, 0x69, 0x6f, 0x6e, 0x12,
	0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75,
	0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61,
	0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x47, 0x0a, 0x13, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x52,
	0x65, 0x64, 0x75, 0x63, 0x65, 0x64, 0x4d, 0x6f, 0x74, 0x69, 0x6f, 0x6e, 0x12, 0x16, 0x2e, 0x67,
	0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45,
	0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x48,
	0x0a, 0x14, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x52, 0x65, 0x64, 0x75, 0x63, 0x65, 0x64,
	0x4d, 0x6f, 0x74, 0x69, 0x6f, 0x6e, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16,
	0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66,
	0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x44, 0x0a, 0x0c, 0x47, 0x65, 0x74, 0x4c,
	0x61, 0x72, 0x67, 0x65, 0x54, 0x65, 0x78, 0x74, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x43,
	0x0a, 0x0f, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x4c, 0x61, 0x72, 0x67, 0x65, 0x54, 0x65, 0x78,
	0x74, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74,
	0x79, 0x22, 0x00, 0x12, 0x44, 0x0a, 0x10, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x4c, 0x61,
	0x72, 0x67, 0x65, 0x54, 0x65, 0x78, 0x74, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a,
	0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75,
	0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x47, 0x0a, 0x0f, 0x47, 0x65, 0x74,
	0x53, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x12, 0x16, 0x2e, 0x67,
	0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45,
	0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65,
	0x22, 0x00, 0x12, 0x46, 0x0a, 0x12, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x63, 0x72, 0x65,
	0x65, 0x6e, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x47, 0x0a, 0x13, 0x44, 0x69,
	0x73, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x52, 0x65, 0x61, 0x64, 0x65,
	0x72, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74,
	0x79, 0x22, 0x00, 0x12, 0x47, 0x0a, 0x0f, 0x47, 0x65, 0x74, 0x56, 0x69, 0x73, 0x75, 0x61, 0x6c,
	0x41, 0x6c, 0x65, 0x72, 0x74, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a,
	0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66,
	0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x46, 0x0a, 0x12,
	0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x56, 0x69, 0x73, 0x75, 0x61, 0x6c, 0x41, 0x6c, 0x65, 0x72,
	0x74, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f,
	0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70,
	0x74, 0x79, 0x22, 0x00, 0x12, 0x47, 0x0a, 0x13, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x56,
	0x69, 0x73, 0x75, 0x61, 0x6c, 0x41, 0x6c, 0x65, 0x72, 0x74, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f,
	0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d,
	0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x49, 0x0a,
	0x11, 0x47, 0x65, 0x74, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x4b, 0x65, 0x79, 0x62, 0x6f, 0x61,
	0x72, 0x64, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f,
	0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f,
	0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x48, 0x0a, 0x14, 0x45, 0x6e, 0x61, 0x62,
	0x6c, 0x65, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6e, 0x4b, 0x65, 0x79, 0x62, 0x6f, 0x61, 0x72, 0x64,
	0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x22, 0x00, 0x12, 0x49, 0x0a, 0x15, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x63, 0x72,
	0x65, 0x65, 0x6e, 0x4b, 0x65, 0x79, 0x62, 0x6f, 0x61, 0x72, 0x64, 0x12, 0x16, 0x2e, 0x67, 0x6f,
	0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d,
	0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x45, 0x0a,
	0x0d, 0x47, 0x65, 0x74, 0x53, 0x74, 0x69, 0x63, 0x6b, 0x79, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16,
	0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66,
	0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61, 0x6c,
	0x75, 0x65, 0x22, 0x00, 0x12, 0x44, 0x0a, 0x10, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x74,
	0x69, 0x63, 0x6b, 0x79, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x45, 0x0a, 0x11, 0x44, 0x69,
	0x73, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x74, 0x69, 0x63, 0x6b, 0x79, 0x4b, 0x65, 0x79, 0x73, 0x12,
	0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75,
	0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22,
	0x00, 0x12, 0x43, 0x0a, 0x0b, 0x47, 0x65, 0x74, 0x53, 0x6c, 0x6f, 0x77, 0x4b, 0x65, 0x79, 0x73,
	0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56,
	0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x42, 0x0a, 0x0e, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65,
	0x53, 0x6c, 0x6f, 0x77, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x43, 0x0a, 0x0f, 0x44, 0x69,
	0x73, 0x61, 0x62, 0x6c, 0x65, 0x53, 0x6c, 0x6f, 0x77, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16, 0x2e,
	0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e,
	0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12,
	0x44, 0x0a, 0x0c, 0x47, 0x65, 0x74, 0x4d, 0x6f, 0x75, 0x73, 0x65, 0x4b, 0x65, 0x79, 0x73, 0x12,
	0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75,
	0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f, 0x6c, 0x56, 0x61,
	0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x43, 0x0a, 0x0f, 0x45, 0x6e, 0x61, 0x62, 0x6c, 0x65, 0x4d,
	0x6f, 0x75, 0x73, 0x65, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79,
	0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62,
	0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12, 0x44, 0x0a, 0x10, 0x44, 0x69,
	0x73, 0x61, 0x62, 0x6c, 0x65, 0x4d, 0x6f, 0x75, 0x73, 0x65, 0x4b, 0x65, 0x79, 0x73, 0x12, 0x16,
	0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66,
	0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00,
	0x12, 0x46, 0x0a, 0x0e, 0x47, 0x65, 0x74, 0x44, 0x65, 0x73, 0x6b, 0x74, 0x6f, 0x70, 0x5a, 0x6f,
	0x6f, 0x6d, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x1a, 0x2e, 0x67, 0x6f, 0x6f,
	0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x42, 0x6f, 0x6f,
	0x6c, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x22, 0x00, 0x12, 0x45, 0x0a, 0x11, 0x45, 0x6e, 0x61, 0x62,
	0x6c, 0x65, 0x44, 0x65, 0x73, 0x6b, 0x74, 0x6f, 0x70, 0x5a, 0x6f, 0x6f, 0x6d, 0x12, 0x16, 0x2e,
	0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e,
	0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x12,
	0x46, 0x0a, 0x12, 0x44, 0x69, 0x73, 0x61, 0x62, 0x6c, 0x65, 0x44, 0x65, 0x73, 0x6b, 0x74, 0x6f,
	0x70, 0x5a, 0x6f, 0x6f, 0x6d, 0x12, 0x16, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x45, 0x6d, 0x70, 0x74, 0x79, 0x1a, 0x16, 0x2e,
	0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e,
	0x45, 0x6d, 0x70, 0x74, 0x79, 0x22, 0x00, 0x42, 0x3b, 0x5a, 0x39, 0x67, 0x69, 0x74, 0x68, 0x75,
	0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x63, 0x61, 0x6e, 0x6f, 0x6e, 0x69, 0x63, 0x61, 0x6c, 0x2f,
	0x75, 0x62, 0x75, 0x6e, 0x74, 0x75, 0x2d, 0x64, 0x65, 0x73, 0x6b, 0x74, 0x6f, 0x70, 0x2d, 0x70,
	0x72, 0x6f, 0x76, 0x69, 0x73, 0x69, 0x6f, 0x6e, 0x2f, 0x70, 0x72, 0x6f, 0x76, 0x64, 0x2f, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
})

var file_protos_accessibility_proto_goTypes = []any{
	(*emptypb.Empty)(nil),        // 0: google.protobuf.Empty
	(*wrapperspb.BoolValue)(nil), // 1: google.protobuf.BoolValue
}
var file_protos_accessibility_proto_depIdxs = []int32{
	0,  // 0: accessibility.AccessibilityService.GetHighContrast:input_type -> google.protobuf.Empty
	0,  // 1: accessibility.AccessibilityService.EnableHighContrast:input_type -> google.protobuf.Empty
	0,  // 2: accessibility.AccessibilityService.DisableHighContrast:input_type -> google.protobuf.Empty
	0,  // 3: accessibility.AccessibilityService.GetReducedMotion:input_type -> google.protobuf.Empty
	0,  // 4: accessibility.AccessibilityService.EnableReducedMotion:input_type -> google.protobuf.Empty
	0,  // 5: accessibility.AccessibilityService.DisableReducedMotion:input_type -> google.protobuf.Empty
	0,  // 6: accessibility.AccessibilityService.GetLargeText:input_type -> google.protobuf.Empty
	0,  // 7: accessibility.AccessibilityService.EnableLargeText:input_type -> google.protobuf.Empty
	0,  // 8: accessibility.AccessibilityService.DisableLargeText:input_type -> google.protobuf.Empty
	0,  // 9: accessibility.AccessibilityService.GetScreenReader:input_type -> google.protobuf.Empty
	0,  // 10: accessibility.AccessibilityService.EnableScreenReader:input_type -> google.protobuf.Empty
	0,  // 11: accessibility.AccessibilityService.DisableScreenReader:input_type -> google.protobuf.Empty
	0,  // 12: accessibility.AccessibilityService.GetVisualAlerts:input_type -> google.protobuf.Empty
	0,  // 13: accessibility.AccessibilityService.EnableVisualAlerts:input_type -> google.protobuf.Empty
	0,  // 14: accessibility.AccessibilityService.DisableVisualAlerts:input_type -> google.protobuf.Empty
	0,  // 15: accessibility.AccessibilityService.GetScreenKeyboard:input_type -> google.protobuf.Empty
	0,  // 16: accessibility.AccessibilityService.EnableScreenKeyboard:input_type -> google.protobuf.Empty
	0,  // 17: accessibility.AccessibilityService.DisableScreenKeyboard:input_type -> google.protobuf.Empty
	0,  // 18: accessibility.AccessibilityService.GetStickyKeys:input_type -> google.protobuf.Empty
	0,  // 19: accessibility.AccessibilityService.EnableStickyKeys:input_type -> google.protobuf.Empty
	0,  // 20: accessibility.AccessibilityService.DisableStickyKeys:input_type -> google.protobuf.Empty
	0,  // 21: accessibility.AccessibilityService.GetSlowKeys:input_type -> google.protobuf.Empty
	0,  // 22: accessibility.AccessibilityService.EnableSlowKeys:input_type -> google.protobuf.Empty
	0,  // 23: accessibility.AccessibilityService.DisableSlowKeys:input_type -> google.protobuf.Empty
	0,  // 24: accessibility.AccessibilityService.GetMouseKeys:input_type -> google.protobuf.Empty
	0,  // 25: accessibility.AccessibilityService.EnableMouseKeys:input_type -> google.protobuf.Empty
	0,  // 26: accessibility.AccessibilityService.DisableMouseKeys:input_type -> google.protobuf.Empty
	0,  // 27: accessibility.AccessibilityService.GetDesktopZoom:input_type -> google.protobuf.Empty
	0,  // 28: accessibility.AccessibilityService.EnableDesktopZoom:input_type -> google.protobuf.Empty
	0,  // 29: accessibility.AccessibilityService.DisableDesktopZoom:input_type -> google.protobuf.Empty
	1,  // 30: accessibility.AccessibilityService.GetHighContrast:output_type -> google.protobuf.BoolValue
	0,  // 31: accessibility.AccessibilityService.EnableHighContrast:output_type -> google.protobuf.Empty
	0,  // 32: accessibility.AccessibilityService.DisableHighContrast:output_type -> google.protobuf.Empty
	1,  // 33: accessibility.AccessibilityService.GetReducedMotion:output_type -> google.protobuf.BoolValue
	0,  // 34: accessibility.AccessibilityService.EnableReducedMotion:output_type -> google.protobuf.Empty
	0,  // 35: accessibility.AccessibilityService.DisableReducedMotion:output_type -> google.protobuf.Empty
	1,  // 36: accessibility.AccessibilityService.GetLargeText:output_type -> google.protobuf.BoolValue
	0,  // 37: accessibility.AccessibilityService.EnableLargeText:output_type -> google.protobuf.Empty
	0,  // 38: accessibility.AccessibilityService.DisableLargeText:output_type -> google.protobuf.Empty
	1,  // 39: accessibility.AccessibilityService.GetScreenReader:output_type -> google.protobuf.BoolValue
	0,  // 40: accessibility.AccessibilityService.EnableScreenReader:output_type -> google.protobuf.Empty
	0,  // 41: accessibility.AccessibilityService.DisableScreenReader:output_type -> google.protobuf.Empty
	1,  // 42: accessibility.AccessibilityService.GetVisualAlerts:output_type -> google.protobuf.BoolValue
	0,  // 43: accessibility.AccessibilityService.EnableVisualAlerts:output_type -> google.protobuf.Empty
	0,  // 44: accessibility.AccessibilityService.DisableVisualAlerts:output_type -> google.protobuf.Empty
	1,  // 45: accessibility.AccessibilityService.GetScreenKeyboard:output_type -> google.protobuf.BoolValue
	0,  // 46: accessibility.AccessibilityService.EnableScreenKeyboard:output_type -> google.protobuf.Empty
	0,  // 47: accessibility.AccessibilityService.DisableScreenKeyboard:output_type -> google.protobuf.Empty
	1,  // 48: accessibility.AccessibilityService.GetStickyKeys:output_type -> google.protobuf.BoolValue
	0,  // 49: accessibility.AccessibilityService.EnableStickyKeys:output_type -> google.protobuf.Empty
	0,  // 50: accessibility.AccessibilityService.DisableStickyKeys:output_type -> google.protobuf.Empty
	1,  // 51: accessibility.AccessibilityService.GetSlowKeys:output_type -> google.protobuf.BoolValue
	0,  // 52: accessibility.AccessibilityService.EnableSlowKeys:output_type -> google.protobuf.Empty
	0,  // 53: accessibility.AccessibilityService.DisableSlowKeys:output_type -> google.protobuf.Empty
	1,  // 54: accessibility.AccessibilityService.GetMouseKeys:output_type -> google.protobuf.BoolValue
	0,  // 55: accessibility.AccessibilityService.EnableMouseKeys:output_type -> google.protobuf.Empty
	0,  // 56: accessibility.AccessibilityService.DisableMouseKeys:output_type -> google.protobuf.Empty
	1,  // 57: accessibility.AccessibilityService.GetDesktopZoom:output_type -> google.protobuf.BoolValue
	0,  // 58: accessibility.AccessibilityService.EnableDesktopZoom:output_type -> google.protobuf.Empty
	0,  // 59: accessibility.AccessibilityService.DisableDesktopZoom:output_type -> google.protobuf.Empty
	30, // [30:60] is the sub-list for method output_type
	0,  // [0:30] is the sub-list for method input_type
	0,  // [0:0] is the sub-list for extension type_name
	0,  // [0:0] is the sub-list for extension extendee
	0,  // [0:0] is the sub-list for field type_name
}

func init() { file_protos_accessibility_proto_init() }
func file_protos_accessibility_proto_init() {
	if File_protos_accessibility_proto != nil {
		return
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: unsafe.Slice(unsafe.StringData(file_protos_accessibility_proto_rawDesc), len(file_protos_accessibility_proto_rawDesc)),
			NumEnums:      0,
			NumMessages:   0,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_protos_accessibility_proto_goTypes,
		DependencyIndexes: file_protos_accessibility_proto_depIdxs,
	}.Build()
	File_protos_accessibility_proto = out.File
	file_protos_accessibility_proto_goTypes = nil
	file_protos_accessibility_proto_depIdxs = nil
}
