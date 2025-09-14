class UpdateAdafruitAccountRequest {
  final String username;
  final String apiKey;

  UpdateAdafruitAccountRequest({required this.username, required this.apiKey});

  Map<String, dynamic> toJson() => {'username': username, 'apiKey': apiKey};
}
