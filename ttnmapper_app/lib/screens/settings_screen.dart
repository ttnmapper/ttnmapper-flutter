import 'package:flutter/material.dart';
import 'package:ttnmapper_app/models/settings.dart';
import 'package:ttnmapper_app/services/preference_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mqttUrlController = TextEditingController();
  TextEditingController _appIdController = TextEditingController();
  TextEditingController _appAccessKeyController = TextEditingController();

  String _mqttBrokerUrl;
  String _applicationId;
  String _applicationAccessKey;

  @override
  void initState() {
    super.initState();

    PreferenceService.load().then((settings){
      setState(() {
        this._mqttUrlController.text = '${settings.mqttBrokerHost}:${settings.mqttBrokerPort}';
        this._appIdController.text = settings.applicationId;
        this._appAccessKeyController.text = settings.applicationAccessKey;
      });
    });
  }

  void submit(context) {
    final FormState form = _formKey.currentState;

    // Validate form first.
    if (!form.validate()) {
      final snackBar = SnackBar(
        content: Text('Invalid settings.'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      // Save form.
      form.save();

      // Persist settings.
      final settings = Settings(
        applicationId: _applicationId,
        applicationAccessKey: _applicationAccessKey,
        mqttBrokerHost: _mqttBrokerUrl,
      );
      PreferenceService.persist(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _mqttUrlController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter MQTT broker URL';
                          }
                          return null;
                        },
                        onSaved: (val) => _mqttBrokerUrl = val,
                      ),
                      TextFormField(
                        controller: _appIdController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter ApplicationID';
                          }
                          return null;
                        },
                        onSaved: (val) => _applicationId = val,
                      ),
                      TextFormField(
                        controller: _appAccessKeyController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Application Access Key';
                          }
                          return null;
                        },
                        onSaved: (val) => _applicationAccessKey= val,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () => submit(context),
                          child: Text('Save'),
                        ),
                      ),
                    ])
            )
          ]
      )
    );
  }
}