import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/widgets/commonTextFormFeild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();
  static final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Form(
              //key: _logInKey,
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Login now',
                    style: GoogleFonts.montserrat(
                        color: textColor,
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                commonTextFormField(false,'Email', emailController,(String? value){
                  if(!emailRegex.hasMatch(value.toString())) {
                    return 'Email Format not matching';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 15,
                ),
                commonTextFormField(true,'Password', passController,(String? value){
                  if(value!.length<6){
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 30,
                ),
                // loginAuthButton(context, 'Login'),
                InkWell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      'I don\'t have an account',
                      style: GoogleFonts.montserrat(
                        color: subTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (_)=>const SignUpScreen()));
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // socialMediaIntegrationButtons(),
                //app logo
                // AnimatedPositioned(
                //     top: mq.height * .15,
                //     right: _isAnimate ? mq.width * .25 : -mq.width * .5,
                //     width: mq.width * .5,
                //     duration: const Duration(seconds: 1),
                //     child: Image.asset('images/icon.png')),

                //google login button
                // Positioned(
                //     bottom: mq.height * .15,
                //     left: mq.width * .05,
                //     width: mq.width * .9,
                //     height: mq.height * .06,
                //     child: ElevatedButton.icon(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                //             shape: const StadiumBorder(),
                //             elevation: 1),
                //         onPressed: () {
                //           _handleGoogleBtnClick();
                //         },
                //
                //         //google icon
                //         icon: Image.asset('images/google.png', height: mq.height * .03),
                //
                //         //login with google label
                //         label: RichText(
                //           text: const TextSpan(
                //               style: TextStyle(color: Colors.black, fontSize: 16),
                //               children: [
                //                 TextSpan(text: 'Login with '),
                //                 TextSpan(
                //                     text: 'Google',
                //                     style: TextStyle(fontWeight: FontWeight.w500)),
                //               ]),
                //         ))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
  Widget loginAuthButton(BuildContext context, String buttonName) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          buttonName,
          style: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      onTap: () async{
        if(_logInKey.currentState!.validate()){
          print('Validated');
          final EmailLoginResults emailLoginResults=await loginWithEmailAndPassAuth(
              email: emailController.text,
              password: passController.text);
          print(emailLoginResults);
          String msg='';
          if(emailLoginResults==EmailLoginResults.SignInCompleted){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_)=>HomeScreen()),
                    (route) => false);
            msg='Login Complete';
          }else if(emailLoginResults==EmailLoginResults.EmailNotVerified){
            msg='Email is not Verified.\nPlease Verify your email then Login';
          }else if(emailLoginResults==EmailLoginResults.EmailOrPasswordInvalid){
            msg='Email And Password Invalid';
          }else{
            msg='Login Not Complete';
          }
          if(msg!=''){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          }
        }
        else{
          print('Not Validated');
        }
      },
    );
  }
}
