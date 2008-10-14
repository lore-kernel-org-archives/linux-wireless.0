Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:37406 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJNOWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 10:22:37 -0400
Received: from [192.168.1.10] (ool-44c60ac6.dyn.optonline.net [68.198.10.198])
 by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K8Q005IOFXMC060@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Tue, 14 Oct 2008 10:22:35 -0400 (EDT)
Date: Tue, 14 Oct 2008 10:22:33 -0400
From: Jerry Quinn <jlquinn@optonline.net>
Subject: ath5k: No connection with 5424 and latest compat-old
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Message-id: <48F4AB29.5030303@optonline.net> (sfid-20081014_162244_235356_6B47E886)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've installed the latest compat-wireless-2.6-old on Debian 2.6.26-1 
i686 v2.6.26-7.  I downloaded it last night Oct 13, 2008.

naga:~/compat-wireless-2.6-old# cat compat-release
v4.5-56-gcd7615b

I can build, install, and modprobe the ath5k module, giving:

Oct  14 23:31:09 naga kernel: [17974.660295] ACPI: PCI Interrupt 
0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
Oct  14 23:31:09 naga kernel: [17974.660368] ath5k_pci 0000:03:00.0: 
registered as 'phy0'
Oct  14 23:31:09 naga kernel: [17974.789588] phy0: Selected rate control 
algorithm 'pid'
Oct  14 23:31:09 naga kernel: [17974.790580] Registered led device: 
ath5k-phy0::rx
Oct  14 23:31:09 naga kernel: [17974.790602] Registered led device: 
ath5k-phy0::tx
Oct  14 23:31:09 naga kernel: [17974.790605] ath5k phy0: Atheros AR5424 
chip found (MAC: 0xa3, PHY: 0x61)
Oct  14 23:31:09 naga kernel: [17974.814333] udev: renamed network 
interface wlan0 to ath0

When I try to ifup the interface, connecting through DHCP, I get no 
connection, and in the kernel log, I just get:

Oct  5 20:32:17 naga kernel: [18042.759550] ADDRCONF(NETDEV_UP): ath0: 
link is not ready

iwlist ath0 scan works, however.

Thanks,
Jerry Quinn


