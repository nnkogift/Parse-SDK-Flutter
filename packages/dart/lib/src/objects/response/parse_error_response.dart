part of flutter_parse_sdk;

/// Handles any errors returned in response
ParseResponse? buildErrorResponse(
    ParseResponse response, ParseNetworkResponse? apiResponse) {
  if (apiResponse?.data == null) {
    return null;
  }

  print(apiResponse!.data);
  final Map<String, dynamic> responseData = json.decode(apiResponse.data);

  print(responseData.toString());

  response.error = ParseError(
      code: responseData[keyCode], message: responseData[keyError].toString());
  response.statusCode = responseData[keyCode];
  return response;
}
