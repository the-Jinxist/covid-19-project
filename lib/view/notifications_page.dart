import 'package:covid_tracker_app/model/resource.dart';
import 'package:covid_tracker_app/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final notificationViewModel = context.read<NotificationViewModel>();
      notificationViewModel.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Notifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'These are notifications from people that have sent their anonymous symptoms to us',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<NotificationViewModel>(
                builder: (context, viewmodel, _) {
                  if (viewmodel.getNotificationsResource.ops ==
                      NetworkStatus.LOADING) {
                    return SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (viewmodel.getNotificationsResource.ops ==
                      NetworkStatus.FAILED) {
                    return SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Text(
                            'Sorry, an error occurred',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final locationViewModel =
                                  context.read<NotificationViewModel>();
                              locationViewModel.getAllNotifications();
                            },
                            child: const Text(
                              'Reload',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final locations =
                        viewmodel.getNotificationsResource.modelResponse ?? [];

                    if (locations.isEmpty) {
                      return SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "You have no notifications for now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                final locationViewModel =
                                    context.read<NotificationViewModel>();
                                locationViewModel.getAllNotifications();
                              },
                              child: const Text(
                                'Reload',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: locations.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.location_pin,
                            color: Colors.green,
                          ),
                          minLeadingWidth: 20,
                          dense: true,
                          title: Text(
                            "${locations[index].title}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            locations[index].notificationDesc!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
