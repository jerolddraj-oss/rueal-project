# Azure Landing Zone - Architecture

This implementation follows the supplied reference drawing and separates platform concerns from workload spokes.

## Layers

1. **Management hierarchy** - Landing-Zone parent with Platform, Identity, Connectivity, Management, Workloads and Sandbox children. Existing subscriptions are associated to the correct management group; Terraform does not create billing subscriptions.
2. **Hub network** - Central VNet with optional Azure Firewall, Bastion, VPN/ExpressRoute Gateway and Private DNS Resolver.
3. **Spokes** - Dev/Prod/application VNets with workload subnets, NSGs, and optional default route to the hub firewall.
4. **Policy** - Allowed locations and required tags assigned at the Landing-Zone management group. Start in Audit mode and move to Deny after testing.
5. **Operations** - Log Analytics and Action Group, Recovery Services Vault, optional Automation Account.
6. **Identity/Security** - User-assigned managed identity and RBAC-enabled Key Vault. Microsoft Entra tenant objects are intentionally not created by this baseline.
7. **Workloads** - Resource-group containers for application projects. Application-specific compute/data modules can be added without changing the platform layer.

## Traffic flow

`Internet/On-premises -> Hub -> Azure Firewall -> Spoke` for inspected traffic. Spokes peer to the hub; the route table can send `0.0.0.0/0` to the firewall private IP.

For production, add explicit firewall network/application/NAT rules, private endpoints and Private DNS zones according to the application flows. Do not expose databases directly to the Internet.

## Subscription model

Subscription creation is outside this repository. Put subscription IDs into the appropriate `*_subscription_ids` variable so the management-group module can associate them.
