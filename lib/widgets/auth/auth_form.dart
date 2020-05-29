import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

enum AuthMode {
  Login,
  SignUp,
}

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File userImage, bool isLogin, BuildContext ctx) submitFn;
  final isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _passwordInVisible = true;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };
  File _image;
  AuthMode _authMode = AuthMode.Login;
  AnimationController _animationController;
  Animation _opacityAnimation;
  Animation _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _togglePasswordVisibilty() {
    setState(() {
      _passwordInVisible = !_passwordInVisible;
    });
  }

  void _toggleAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.SignUp;
        _animationController.forward();
      } else {
        _authMode = AuthMode.Login;
        _animationController.reverse();
      }
    });
  }

  void _imageFn(File pickedImage) {
    _image = pickedImage;
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (_image == null && _authMode == AuthMode.SignUp) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Pick an Image!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    _formKey.currentState.save();

    widget.submitFn(
        _authData['email'].trim(),
        _authData['username'].trim(),
        _authData['password'].trim(),
        _image,
        _authMode == AuthMode.Login ? true : false,
        context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: _authMode == AuthMode.Login ? 250 : 360,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_authMode == AuthMode.SignUp) UserImagePicker(_imageFn),
                    TextFormField(
                      enabled: widget.isLoading ? false : true,
                      decoration: InputDecoration(labelText: 'Email address'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        value.trim();
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Login ? 0 : 60,
                          maxHeight: _authMode == AuthMode.Login ? 0 : 120),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled: widget.isLoading ? false : true,
                            decoration: InputDecoration(labelText: 'Username'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            onSaved: (value) {
                              _authData['username'] = value;
                            },
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      enabled: widget.isLoading ? false : true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordInVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: _togglePasswordVisibilty,
                        ),
                      ),
                      obscureText: _passwordInVisible,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    // AnimatedContainer(
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeIn,
                    //   constraints: BoxConstraints(
                    //       minHeight: _authMode == AuthMode.Login ? 0 : 60,
                    //       maxHeight: _authMode == AuthMode.Login ? 0 : 120),
                    //   child: FadeTransition(
                    //     opacity: _opacityAnimation,
                    //     child: SlideTransition(
                    //       position: _slideAnimation,
                    //       child: TextFormField(
                    //           decoration: InputDecoration(
                    //             labelText: 'Confirm Password',
                    //             hintText: 'Enter your password again',
                    //           ),
                    //           obscureText: true,
                    //           validator: _authMode == AuthMode.SignUp
                    //               ? (value) {
                    //                   value.trim();
                    //                   if (value != _passwordController.text) {
                    //                     return 'Passwords do not match!';
                    //                   }
                    //                   return null;
                    //                 }
                    //               : null),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading)
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: CircularProgressIndicator()),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(_authMode == AuthMode.Login
                            ? 'Login'
                            : 'Create Account'),
                        onPressed: submit,
                      ),
                    if (!widget.isLoading)
                      Divider(
                        thickness: 1,
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        onPressed: _toggleAuthMode,
                        child: Text(_authMode == AuthMode.Login
                            ? 'Create New Account'
                            : 'Already have an account? Login'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
