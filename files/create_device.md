## Device Provisioning

This section explains how to create and configure devices in the IoT Agent, using either a predefined model or a custom model created through the Smart Data Model Builder, and how their attributes are mapped to Orion.

---

## 1. Selecting or Creating a Device Model

You can select a predefined device model from the **Device Models List** or create your own using the **Smart Data Model Builder**.

![](img/4.png)

---

## 2. Creating a Custom Device Model

When creating a custom model, you must fill in the following fields:

- Model name  
- Short description  
- Category  
- Device ID  
- Entity name  
- Entity type (must match the one defined in the Service Group)  
- Transport protocol (HTTP or MQTT)
- Agent (JSON or UltraLight, depending on the selected protocol)  
- Device attributes  

After filling in the form, click **Generate Template**.

Then choose one of the following options:

- **Save Model**: saves the model in the database and makes it available in the **Device Models List**
- **Save and Use Model**: saves the model, displays it in the list, and automatically configures the agent to use it

![](img/7.png)

---

## 3. IoT Agent Configuration Context

The Service Group defines:

- The *resource* where the IoT Agent is listening (automatically generated based on the selected agent)
- The *apikey* used to authenticate requests

Once both are recognized, the measurements become valid.

---

## 4. Agent Compatibility Rule

The selected agent must be compatible with the *resource* generated in the Service Group:

- If the **UltraLight protocol** is selected, the device must use the **AgentUltraLight**
- Otherwise, the default agent is **JSON**

---

## 5. Provisioning a Device (from a model)

To use a predefined model, select one from the list and click **Use Model**.

This action provisions the device in the **IoT Agent**.

![](img/8.png)

---

## 6. Device Mapping Behavior

Since the device was explicitly provisioned, the IoT Agent can map attributes before forwarding the request to **Orion**.