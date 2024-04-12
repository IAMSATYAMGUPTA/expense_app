mixin ValidatorMixin{
  String? emailValidate(value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? passValidate(value) {
    if (value == "") {
      return "Please fill the Pass Field!!";
    } else if (value!.length < 5) {
      return "Please enter an valid Password (password must contain atleast 5 chars)";
    }

    return null;
  }

}