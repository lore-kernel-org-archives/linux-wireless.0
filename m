Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58986 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbZKNLtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 06:49:40 -0500
Received: by bwz27 with SMTP id 27so4270399bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 03:49:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911021522.38842.mb@bu3sch.de>
References: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com>
	<69e28c910911020326m67797910ub1df048d8dd3eb7e@mail.gmail.com>
	<4888b8cb0911020557m226d8bccx36da7949459369f@mail.gmail.com>
	<200911021522.38842.mb@bu3sch.de>
From: Thomas Wiecki <thomas.wiecki@googlemail.com>
Date: Sat, 14 Nov 2009 12:49:25 +0100
Message-ID: <4888b8cb0911140349h6b7c9f3du64a633fd6d56829@mail.gmail.com>
Subject: Re: b43 with 14e4 gives DMA error
To: Michael Buesch <mb@bu3sch.de>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is probably what you requested:

[  144.223547] b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17
(level, low) -> IRQ 17
[  144.223563] b43-pci-bridge 0000:0c:00.0: setting latency timer to 64
[  144.297386] ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
[  144.555613] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[  144.613238] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
[  144.613255] b43-phy0 debug: Found Radio: Manuf 0x17F, Version
0x2062, Revision 2
[  144.732440] phy0: Selected rate control algorithm 'minstrel'
[  144.735288] Registered led device: b43-phy0::tx
[  144.735333] Registered led device: b43-phy0::rx
[  144.735375] Registered led device: b43-phy0::radio
[  144.735489] Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
[  144.788270] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[  145.036087] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[  145.245282] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[  145.420475] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[  145.422895] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[  146.943122] __ratelimit: 18 callbacks suppressed
[  146.943126] type=1503 audit(1258156036.311:48):
operation="truncate" info="Failed name lookup - deleted entry"
error=-2 pid=2488 parent=2275 profile="/usr/lib/firefox-3.5.*/firefox"
requested_mask="w::" denied_mask="w::" fsuid=1000 ouid=1000
name=2F7661722F746D702F6574696C71735F4F52595068314A614B527537437537202864656C6574656429
[  151.252345] b43-phy0 debug: Chip initialized
[  151.252611] b43-phy0 debug: 64-bit DMA initialized
[  151.252899] b43-phy0 debug: QoS enabled
[  151.274853] b43-phy0 debug: Wireless interface started
[  151.274870] b43-phy0 debug: Adding Interface type 2
[  151.286248] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  162.465561] b43-phy0 ERROR: Fatal DMA error: 0x00000800,
0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[  162.465577] b43-phy0: Controller RESET (DMA error) ...
[  162.466070] b43-phy0 debug: Wireless interface stopped
[  162.466082] b43-phy0 debug: DMA-64 rx_ring: Used slots 1/64, Failed
frames 0/0 = 0.0%, Average tries 0.00
[  162.466170] b43-phy0 debug: DMA-64 tx_ring_AC_BK: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  162.473232] b43-phy0 debug: DMA-64 tx_ring_AC_BE: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  162.481232] b43-phy0 debug: DMA-64 tx_ring_AC_VI: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  162.489262] b43-phy0 debug: DMA-64 tx_ring_AC_VO: Used slots 2/256,
Failed frames 0/22 = 0.0%, Average tries 1.00
[  162.497240] b43-phy0 debug: DMA-64 tx_ring_mcast: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  162.692325] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[  162.694773] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[  168.188513] b43-phy0 debug: Chip initialized
[  168.188776] b43-phy0 debug: 64-bit DMA initialized
[  168.189087] b43-phy0 debug: QoS enabled
[  168.209436] b43-phy0 debug: Wireless interface started
[  168.209449] b43-phy0: Controller restarted
[  168.218037] b43-phy0 ERROR: Fatal DMA error: 0x00000400,
0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
[  168.218051] b43-phy0: Controller RESET (DMA error) ...
[  168.221400] b43-phy0 debug: Wireless interface stopped
[  168.221415] b43-phy0 debug: DMA-64 rx_ring: Used slots 0/64, Failed
frames 0/0 = 0.0%, Average tries 0.00
[  168.221503] b43-phy0 debug: DMA-64 tx_ring_AC_BK: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  168.229061] b43-phy0 debug: DMA-64 tx_ring_AC_BE: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  168.237052] b43-phy0 debug: DMA-64 tx_ring_AC_VI: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  168.245036] b43-phy0 debug: DMA-64 tx_ring_AC_VO: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00
[  168.253208] b43-phy0 debug: DMA-64 tx_ring_mcast: Used slots 0/256,
Failed frames 0/0 = 0.0%, Average tries 0.00

Does this help?

On Mon, Nov 2, 2009 at 3:22 PM, Michael Buesch <mb@bu3sch.de> wrote:
> Can we have a full kernel log with b43 debugging enabled, please? (CONFIG_B43_DEBUG)
>
> --
> Greetings, Michael.
>
