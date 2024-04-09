part of 'post_chemical_data_bloc.dart';

sealed class PostChemicalDataEvent extends Equatable {
  const PostChemicalDataEvent();

  @override
  List<Object> get props => [];
}

final class OnCreatePdfBUttonPressed extends PostChemicalDataEvent {
  final String pdfPath;
  final String cName;
  final String sName;
  final String pdfName;
  OnCreatePdfBUttonPressed(
      {required this.pdfPath,
      required this.cName,
      required this.sName,
      required this.pdfName});
}
