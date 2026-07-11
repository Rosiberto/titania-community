## Creating a Service Group

A **Service Group** in TiTaniA is a configuration used to group IoT devices that share the same settings, such as protocol, authentication, and data processing rules.

It simplifies device management by centralizing how devices are provisioned and how their data is handled by the platform.



- On the interface, select **Service Group**. 

![](img/4.png)

A **Service Group** in TiTaniA requires the user to specify an `Entity Type` and the `communication/transport protocol` that will be used by the Service Group during its configuration.

The supported protocols are:

- *JSON* over HTTP
- *JSON* over MQTT
- *UltraLight* over HTTP
- *UltraLight* over MQTT

After clicking **Save**, the platform automatically generates an `Apikey` and a `Resource` identifier for the Service Group.

If **UltraLight over HTTP** or **UltraLight over MQTT** is selected, the **AgentUltraLight** service must be installed from the **Marketplace** under **Available Services** before provisioning the Service Group.

If **JSON over MQTT** is selected, the **Eclipse Mosquitto** service must be installed from the **Marketplace** under **Available Services** before provisioning the Service Group.

The generated **API Key** and **Resource** values are used by devices to send data to the IoT Agent, which processes the incoming messages and forwards the corresponding context information to the Orion Context Broker.

Devices can publish data using these credentials even if they have not been explicitly provisioned in advance.

---

![](img/5.png)

- Service Group created.

![](img/6.png)


In this example, devices authenticate using the API key `2b58f46a542446a49e2366f929918aa4`.

Both JSON IoT Agent and UltraLight IoT Agent forward device measurements to the TiTaniA Platform API through the `/api/send` endpoint, as described in the API documentation.

```
http://<platform-host>/api/send
```

For details about the request format, supported protocols, and payload examples, refer to the following documentation page:

<a href="api.md">TiTaniA API Reference</a>