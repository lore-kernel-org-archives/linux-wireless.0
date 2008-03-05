Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:48681 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764236AbYCEMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 07:23:23 -0500
Received: from [192.168.1.10] (ool-44c60ac6.dyn.optonline.net [68.198.10.198])
 by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JX900ETUACXNJY0@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Wed, 05 Mar 2008 06:53:22 -0500 (EST)
Date: Wed, 05 Mar 2008 06:53:21 -0500
From: Jerry Quinn <jlquinn@optonline.net>
Subject: [Fwd: ath5k not working on 5212 mini-pci card]
To: linux-wireless@vger.kernel.org
Message-id: <47CE89B1.3050405@optonline.net> (sfid-20080305_122327_231347_01C20F08)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.  I just downloaded the wireless compat package (2008-03-04) to try 
out ath5k on my thinkpad T60p.  I'm running Debian testing with the 
Debian 2.6.22 kernel with uname
    Linux naga 2.6.22-3-686 #1 SMP Mon Nov 12 08:32:57 UTC 2007 i686 
GNU/Linux

When I try to load ath5k, I get the following kernel output:

Mar  5 00:03:42 naga kernel: PCI: Enabling device 0000:03:00.0 (0000 -> 
0002)
Mar  5 00:03:42 naga kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 
17 (level, low) -> IRQ 21
Mar  5 00:03:42 naga kernel: PCI: Setting latency timer of device 
0000:03:00.0 to 64
Mar  5 00:03:42 naga kernel: ath5k_pci 0000:03:00.0: registered as 'phy1'
Mar  5 00:03:43 naga kernel: ath5k phy1: failed to wakeup the MAC Chip
Mar  5 00:03:43 naga kernel: ACPI: PCI interrupt for device 0000:03:00.0 
disabled
Mar  5 00:03:43 naga kernel: ath5k_pci: probe of 0000:03:00.0 failed 
with error -5


lspci -vnn gives this for the wireless device:

03:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5212 
802.11abg NIC [168c:1014] (rev 01)
    Subsystem: IBM ThinkPad 11a/b/g Wireless LAN Mini Express Adapter 
(AR5BXB6) [1014:058a]
    Flags: fast devsel, IRQ 21
    Memory at edf00000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 2
    Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
    Capabilities: [60] Express Legacy Endpoint, MSI 00
    Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
    Capabilities: [100] Advanced Error Reporting <?>
    Capabilities: [140] Virtual Channel <?>
    Kernel modules: ath5k

I know the driver is still under development, but thought it might work 
since 168c:0014 is listed as likely working.


Thanks,
Jerry Quinn

</div>
