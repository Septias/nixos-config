{
  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };

  networking.firewall.checkReversePath = "loose";
  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = ["10.100.0.2/24"];
      listenPort = 51820;
      privateKeyFile = "/home/septias/wireguard-keys/private";

      peers = [
        {
          # Public key of the server.
          publicKey = "hu9BnZsMH6Rm8W12+L24fKCx2UddUYcB2s1v2A8Tkwg=";

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0"];

          # Set this to the server IP and port.
          endpoint = "5.223.61.83:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
