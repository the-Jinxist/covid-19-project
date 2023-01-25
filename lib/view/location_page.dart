import 'package:covid_tracker_app/model/resource.dart';
import 'package:covid_tracker_app/viewmodel/location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();

    final locationViewModel = context.read<LocationViewModel>();
    locationViewModel.getAllLocations();
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
                height: 50,
              ),
              const Text(
                'Past Visited Locations',
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
                'These are locations that you have visited and you have scanned the QR code located\nthere',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<LocationViewModel>(
                builder: (context, viewmodel, _) {
                  if (viewmodel.getLocationsResource.ops ==
                      NetworkStatus.LOADING) {
                    return SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (viewmodel.getLocationsResource.ops ==
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
                                  context.read<LocationViewModel>();
                              locationViewModel.getAllLocations();
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
                        viewmodel.getLocationsResource.modelResponse ?? [];

                    if (locations.isEmpty) {
                      return SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Text(
                              "You've not scanned any QR codes at any locations",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                final locationViewModel =
                                    context.read<LocationViewModel>();
                                locationViewModel.getAllLocations();
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
                            "You visited: ${locations[index].title}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "At: ${DateTime.parse(locations[index].visitedLocationTile!).toIso8601String()}",
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
