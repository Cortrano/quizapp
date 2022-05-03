import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(user.displayName ?? 'Guest'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user.photoURL ??
                          'https://www.gravatar.com/avatar/placeholder'),
                    )),
              ),
              Text(
                user.email ?? '',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              Text(
                '${report.total}',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Quizzes Completed',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              ElevatedButton(
                child: const Text('Sign Out'),
                onPressed: () async {
                  AuthService().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    } else {
      return const Loader();
    }
  }
}


// ElevatedButton(
//         child: const Text('Sign Out'),
//         onPressed: () async {
//           AuthService().signOut();
//           Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
//         },
//       ),