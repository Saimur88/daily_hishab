import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          const SizedBox(height: 32,),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null
              ,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null
            ,
            ),
          ),
          const SizedBox(height: 16,),
          Text(
            user!.displayName ?? 'No Name',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            user.email ?? 'No Email',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Ionicons.contrast_outline,size: 30,color: Colors.grey,),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Coming Soon!',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                        title: Text('Theme',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Ionicons.language_outline,size: 30,color: Colors.grey,),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Coming Soon!',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                        title: Text('Change Language',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Ionicons.cash_outline,size: 30,color: Colors.grey,),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Coming Soon!',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                        title: Text('Currency Unit',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Ionicons.arrow_redo_outline,size: 30,color: Colors.grey,),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Coming Soon!',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                        title: Text('Share The App',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout,size: 30),
                        title: Text('Logout',
                        style: Theme.of(context).textTheme.titleMedium,
                          selectionColor: Colors.grey,
                        ),
                        onTap: ()async{
                          final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Logout'))
                                ],
                              ));
                          if (confirm == true) {
                            await FirebaseAuth.instance.signOut();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
