Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:53701 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaCJFGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 01:06:15 -0400
MIME-Version: 1.0
From: Shuduo Sang <sangshuduo@gmail.com>
Date: Mon, 10 Mar 2014 13:05:34 +0800
Message-ID: <CANqatMD5-vD0m+YAsMqYRPNRKQrKSWthv=Gx+sRRO_Ouw7usZQ@mail.gmail.com> (sfid-20140310_060622_062437_1E8DCDDE)
Subject: wifi driver or USB might leads suspend/resume failure on thinkpad X1 carbon
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for cross posting. I'm suffering an issue my Thinkpad X1 Carbon
can't resume after suspend recently. I tried many ways including
latest vanilla kernel, latest stable 3.13 and 3.11 kernel but it still
happens. I found it will not happen when I turn off WIFI device or USB
3.0 in BIOS. So I suspect something need fix in either wifi driver or
USB side. Since Windows 7 works good so I suppose no hardware issue.
Anyone has some ideas to fix it or debug it?

Thanks,
Shuduo


lspci -vnn output:
..
sniped
..
00:1d.0 USB controller: Intel Corporation Lynx Point-LP USB EHCI #1
(rev 04) (prog-if 20 [EHCI])
Subsystem: Lenovo Device 2218
Flags: bus master, medium devsel, latency 0, IRQ 23
Memory at f052d000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 3
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
Kernel driver in use: ehci-pci
..
03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)
Subsystem: Intel Corporation Dual Band Wireless-AC 7260
Flags: bus master, fast devsel, latency 0, IRQ 59
Memory at f0400000 (64-bit, non-prefetchable) [size=8K]
Capabilities: [c8] Power Management version 3
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Capabilities: [40] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Device Serial Number 7c-7a-91-ff-ff-5e-4c-cd
Capabilities: [14c] Latency Tolerance Reporting
Capabilities: [154] Vendor Specific Information: ID=cafe Rev=1 Len=014 <?>
Kernel driver in use: iwlwifi
Kernel modules: iwlwifi
