part of 'upload_pdf_cubit.dart';

sealed class UploadPdfState extends Equatable {
  const UploadPdfState();

  @override
  List<Object> get props => [];
}

final class UploadPdfInitial extends UploadPdfState {}

final class UploadPdfPending extends UploadPdfState {}

final class UploadPdfSuccess extends UploadPdfState {}

final class UploadPdfFailed extends UploadPdfState {}
