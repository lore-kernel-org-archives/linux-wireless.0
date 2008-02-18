Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:46699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYBRH0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 02:26:37 -0500
Received: by ug-out-1314.google.com with SMTP id z38so281845ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 23:26:35 -0800 (PST)
Message-ID: <47B93303.506@gmail.com> (sfid-20080218_072640_702116_4E403F57)
Date: Mon, 18 Feb 2008 08:25:55 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: ronald645@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [BUG?] b43: Wireless signal lowers when increasing sound
References: <47B93277.5030304@gmail.com>
In-Reply-To: <47B93277.5030304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> hey,
> 
> I'm currently using the b43 driver for my BCM4311 chipset. The driver 
> works extremely well. It is the only option under Linux that supports 
> WPA-AES with wpa_supplicant :) (and it's more stable than 
> wpa_supplicant). However, I'm seeing some unexpected behaviour with the 
> card and another chipset. When I enable my soundcard (setting volume 
> from 0 to > 0) the wireless signal seems to drop completely (really 
> funny to see my downloadspeeds go up and down :) ). My question is, is 
> this normal?
> 
> However, I'm not sure if this is related to the b43 driver so don't 
> flame me ;)
> 
>                         TIA, Ronald
> 
Btw, here are my specs (Compaq Presario V6221EU):

00:00.0 RAM memory [0500]: nVidia Corporation C51 Host Bridge 
[10de:02f0] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0
         Capabilities: [44] HyperTransport: Slave or Primary Interface
         Capabilities: [e0] HyperTransport: MSI Mapping Enable- Fixed-

00:00.1 RAM memory [0500]: nVidia Corporation C51 Memory Controller 0 
[10de:02fa] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: 66MHz, fast devsel

00:00.2 RAM memory [0500]: nVidia Corporation C51 Memory Controller 1 
[10de:02fe] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: 66MHz, fast devsel

00:00.3 RAM memory [0500]: nVidia Corporation C51 Memory Controller 5 
[10de:02f8] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: 66MHz, fast devsel

00:00.4 RAM memory [0500]: nVidia Corporation C51 Memory Controller 4 
[10de:02f9] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0

00:00.5 RAM memory [0500]: nVidia Corporation C51 Host Bridge 
[10de:02ff] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0
         Capabilities: [44] #00 [00fe]
         Capabilities: [fc] #00 [0000]

00:00.6 RAM memory [0500]: nVidia Corporation C51 Memory Controller 3 
[10de:027f] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: 66MHz, fast devsel

00:00.7 RAM memory [0500]: nVidia Corporation C51 Memory Controller 2 
[10de:027e] (rev a2)
         Flags: 66MHz, fast devsel

00:02.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge 
[10de:02fc] (rev a1) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: b4000000-b5ffffff
         Prefetchable memory behind bridge: 
00000000d0000000-00000000d01fffff
         Capabilities: [40] Subsystem: nVidia Corporation Unknown device 
[10de:0000]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
         Capabilities: [80] Express Root Port (Slot+), MSI 00
         Capabilities: [100] Virtual Channel <?>
         Kernel driver in use: pcieport-driver

00:03.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge 
[10de:02fd] (rev a1) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
         Memory behind bridge: b6000000-b7ffffff
         Capabilities: [40] Subsystem: nVidia Corporation Unknown device 
[10de:0000]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
         Capabilities: [80] Express Root Port (Slot+), MSI 00
         Capabilities: [100] Virtual Channel <?>
         Kernel driver in use: pcieport-driver

00:05.0 VGA compatible controller [0300]: nVidia Corporation C51 
[Geforce 6150 Go] [10de:0244] (rev a2) (prog-if 00 [VGA controller])
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
         Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
         Memory at c0000000 (64-bit, prefetchable) [size=256M]
         Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
         [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
         Kernel driver in use: nvidia
         Kernel modules: nvidia

00:09.0 RAM memory [0500]: nVidia Corporation MCP51 Host Bridge 
[10de:0270] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0
         Capabilities: [44] HyperTransport: Slave or Primary Interface
         Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-

00:0a.0 ISA bridge [0601]: nVidia Corporation MCP51 LPC Bridge 
[10de:0260] (rev a3)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0
         I/O ports at 1d00 [size=128]

00:0a.1 SMBus [0c05]: nVidia Corporation MCP51 SMBus [10de:0264] (rev a3)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: 66MHz, fast devsel, IRQ 10
         I/O ports at 3040 [size=64]
         I/O ports at 3000 [size=64]
         Capabilities: [44] Power Management version 2

00:0a.3 Co-processor [0b40]: nVidia Corporation MCP51 PMU [10de:0271] 
(rev a3)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
         Memory at b0040000 (32-bit, non-prefetchable) [size=256K]

00:0b.0 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller 
[10de:026d] (rev a3) (prog-if 10 [OHCI])
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 19
         Memory at b0004000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2
         Kernel driver in use: ohci_hcd

00:0b.1 USB Controller [0c03]: nVidia Corporation MCP51 USB Controller 
[10de:026e] (rev a3) (prog-if 20 [EHCI])
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 19
         Memory at b0005000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [44] Debug port: BAR=1 offset=0098
         Capabilities: [80] Power Management version 2
         Kernel driver in use: ehci_hcd

00:0d.0 IDE interface [0101]: nVidia Corporation MCP51 IDE [10de:0265] 
(rev f1) (prog-if 8a [Master SecP PriP])
         Subsystem: Unknown device [f03c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0
         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[disabled] [size=8]
         [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[disabled] [size=1]
         [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
         [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
         I/O ports at 3080 [size=16]
         Capabilities: [44] Power Management version 2
         Kernel driver in use: pata_amd

00:0e.0 IDE interface [0101]: nVidia Corporation MCP51 Serial ATA 
Controller [10de:0266] (rev f1) (prog-if 85 [Master SecO PriO])
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 18
         I/O ports at 30c0 [size=8]
         I/O ports at 30b4 [size=4]
         I/O ports at 30b8 [size=8]
         I/O ports at 30b0 [size=4]
         I/O ports at 3090 [size=16]
         Memory at b0006000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2
         Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/2 Enable-
         Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
         Kernel driver in use: sata_nv

00:10.0 PCI bridge [0604]: nVidia Corporation MCP51 PCI Bridge 
[10de:026f] (rev a2) (prog-if 01 [Subtractive decode])
         Flags: bus master, 66MHz, fast devsel, latency 0
         Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
         Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device 
[0000:0000]
         Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-

00:10.1 Audio device [0403]: nVidia Corporation MCP51 High Definition 
Audio [10de:026c] (rev a2)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
         Memory at b0000000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [44] Power Management version 2
         Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ 
Queue=0/0 Enable-
         Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
         Kernel driver in use: HDA Intel

00:14.0 Bridge [0680]: nVidia Corporation MCP51 Ethernet Controller 
[10de:0269] (rev a3)
         Subsystem: Hewlett-Packard Company Presario V6133CL [103c:30b7]
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
         Memory at b0008000 (32-bit, non-prefetchable) [size=4K]
         I/O ports at 30e0 [size=8]
         Capabilities: [44] Power Management version 2
         Kernel driver in use: forcedeth

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
         Flags: fast devsel
         Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 
[Athlon64/Opteron] Address Map [1022:1101]
         Flags: fast devsel

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 
[Athlon64/Opteron] DRAM Controller [1022:1102]
         Flags: fast devsel

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
         Flags: fast devsel
         Capabilities: [f0] Secure device <?>
         Kernel driver in use: k8temp

03:00.0 Network controller [0280]: Broadcom Corporation BCM94311MCG wlan 
mini-PCI [14e4:4311] (rev 01)
         Subsystem: Hewlett-Packard Company Unknown device [103c:1364]
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at b6000000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
         Capabilities: [d0] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting <?>
         Capabilities: [13c] Virtual Channel <?>
         Kernel driver in use: b43-pci-bridge
