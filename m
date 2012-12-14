Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56029 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2LNIfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 03:35:17 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so5433221ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 00:35:16 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Dec 2012 21:35:16 +1300
Message-ID: <CAKoT1EZh=u3bA6Jcftmsj8cNbGEctVfm_Boi7umzHe1T4EZuTw@mail.gmail.com> (sfid-20121214_093526_102969_8B2D9BA0)
Subject: Problem in FAQ
From: Kevin McCready <kevin1mccready@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--
cheers
kevin1mccready@gmail.com
32 Hawera Rd
Kohimarama 1071
Auckland, New Zealand
+64 (0)9 528 1174 home
+64 (0)226 710 335 cell
http://kmccready.wordpress.com

FAQ says: Forget about XXX, what really matters is PCI or USB
(depending on the bus your device uses) ID pair: VID:PID. So to find
out if your device is supported, use lspci -nn or lsusb to learn the
ID pair.

I have no idea what this means.

I did lspci and got
k@k-Presario-CQ57-Notebook-PC:
~$ lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 3 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 5 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05)
02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
802.11b/g/n WiFi Adapter (rev 01)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5116 PCI Express Card Reader (rev 01)

I did lsusb and got:
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 003: ID 05c8:021e Cheng Uei Precision Industry Co., Ltd (Foxlink)
Bus 002 Device 003: ID 0458:0037 KYE Systems Corp. (Mouse Systems)

I have no idea whether my wireless problem is a usb or pci problem.
I have no idea what the pair is.

I would be grateful for a better FAQ to help me.
