part of 'upload_banner_cubit.dart';

sealed class UploadBannerState extends Equatable {
  const UploadBannerState();

  @override
  List<Object> get props => [];
}

final class UploadBannerInitial extends UploadBannerState {}

final class UploadBannerSuccess extends UploadBannerState {}

final class UploadBannerLoading extends UploadBannerState {}

final class UploadBannerFailed extends UploadBannerState {}
