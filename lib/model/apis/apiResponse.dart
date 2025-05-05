class ApiResponse<T> {
  Status status;
  T? data;
  String? message;
  bool success;  // Changed to non-nullable bool for easier handling

  // Initializing with a message (for the initial state)
  ApiResponse.initial(this.message)
      : status = Status.INITIAL,
        success = false;

  // Loading state with a message (indicating data is being fetched)
  ApiResponse.loading(this.message)
      : status = Status.LOADING,
        success = false;

  // Completed state with data (when the request is successful)
  ApiResponse.completed(this.data)
      : status = Status.COMPLETED,
        success = true;

  // Error state with a message (when the request fails)
  ApiResponse.error(this.message)
      : status = Status.ERROR,
        success = false;

  @override
  String toString() {
    return "Status: $status \nMessage: $message \nData: $data \nSuccess: $success";
  }
}

enum Status { INITIAL, LOADING, COMPLETED, ERROR, uninitialized }
