Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:55356 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYJFAeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 20:34:08 -0400
Received: from [192.168.1.139] (ool-44c60ac6.dyn.optonline.net [68.198.10.198])
 by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K8A00DQ0K8TF1J0@mta2.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sun, 05 Oct 2008 20:34:05 -0400 (EDT)
Date: Sun, 05 Oct 2008 20:34:05 -0400
From: "jlquinn (optonline)" <jlquinn@optonline.net>
Subject: No connection with ath5k 5424
To: linux-wireless@vger.kernel.org
Message-id: <48E95CFD.8080308@optonline.net> (sfid-20081006_023414_038728_0BF0FC91)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've installed the latest compat-wireless-2.6-old on Debian 2.6.26-1 
i686 v2.6.26-6, i.e. the latest available, I believe.

naga:~/compat-wireless-2.6-old# cat compat-release
v4.5-56-gcd7615b

I can build, install, and modprobe the ath5k module, giving:


Oct  5 20:31:09 naga kernel: [17974.660295] ACPI: PCI Interrupt 
0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
Oct  5 20:31:09 naga kernel: [17974.660324] PCI: Setting latency timer 
of device 0000:03:00.0 to 64
Oct  5 20:31:09 naga kernel: [17974.660368] ath5k_pci 0000:03:00.0: 
registered as 'phy0'
Oct  5 20:31:09 naga kernel: [17974.789588] phy0: Selected rate control 
algorithm 'pid'
Oct  5 20:31:09 naga kernel: [17974.790580] Registered led device: 
ath5k-phy0::rx
Oct  5 20:31:09 naga kernel: [17974.790602] Registered led device: 
ath5k-phy0::tx
Oct  5 20:31:09 naga kernel: [17974.790605] ath5k phy0: Atheros AR5424 
chip found (MAC: 0xa3, PHY: 0x61)
Oct  5 20:31:09 naga kernel: [17974.814333] udev: renamed network 
interface wlan0 to ath0

When I try to ifup the interface, connecting through DHCP, I get no 
connection, and in the kernel log, I just get:

Oct  5 20:32:17 naga kernel: [18042.759550] ADDRCONF(NETDEV_UP): ath0: 
link is not ready

iwlist ath0 scan works, however.

Thanks,
Jerry Quinn

