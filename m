Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:9461 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYBUSIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 13:08:07 -0500
Received: by wr-out-0506.google.com with SMTP id c48so195805wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 10:08:06 -0800 (PST)
Message-ID: <84ac67910802211008g73c4231fq76804de69c7b160a@mail.gmail.com> (sfid-20080221_180826_900619_E6531F7C)
Date: Thu, 21 Feb 2008 18:08:05 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: b43 (H/W 4306 Rev. 03)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080221163134.GF3094@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
	 <20080221163134.GF3094@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I wonder if you could try using the firmware from here instead (aka FW11):
>
>         http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2
>
>  Does that improve the situation for you?

Still no joy, I had to force b43-cutter to even extract the firmware:

b43-fwcutter --unsupported /usr/src/broadcom-wl-4.80.53.0/kmod/wl_apsta_mimo.o

Just so you know I am using the latest wireless-testing.git tree.

ACPI: PCI interrupt for device 0000:02:07.0 disabled
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC4] -> GSI 19 (level,
low) -> IRQ 19
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor 0x4243)
ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4243)
ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4243)
ssb: SPROM revision 1 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:02:07.0
b43-phy6: Broadcom 4306 WLAN found
b43-phy6 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy6 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy6: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
Broadcom 43xx driver loaded [ Features: PLID, Firmware-ID: FW10 ]
bonding: bond0: Adding slave wlan0.
b43-phy6: Loading firmware version 351.126 (2006-07-29 05:54:02)
b43-phy6 warning: You are using an old firmware image. Support for old
firmware will be removed in July 2008.
b43-phy6 warning: You must go to
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and
download the latest firmware (version 4).
b43-phy6 debug: Chip initialized
b43-phy6 debug: 30-bit DMA initialized
Registered led device: b43-phy6::tx
Registered led device: b43-phy6::rx
b43-phy6 debug: Wireless interface started
b43-phy6 debug: Adding Interface type 2
bonding: bond0: enslaving wlan0 as an active interface with a down link.
b43-phy6 debug: Using hardware based encryption for keyidx: 0, mac:
ff:ff:ff:ff:ff:ff
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authentication with AP 00:90:d0:f2:ad:7b timed out
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
b43-phy6: Radio turned off by software
b43-phy6 debug: Disabling hardware based encryption for keyidx: 0,
mac: ff:ff:ff:ff:ff:ff
b43-phy6 debug: Removing Interface type 2
b43-phy6 debug: Wireless interface stopped
b43-phy6 debug: DMA-30 0x0200 (RX) max used slots: 1/64
b43-phy6 debug: DMA-30 0x02A0 (TX) max used slots: 0/128
b43-phy6 debug: DMA-30 0x0280 (TX) max used slots: 0/128
b43-phy6 debug: DMA-30 0x0260 (TX) max used slots: 0/128
b43-phy6 debug: DMA-30 0x0240 (TX) max used slots: 0/128
b43-phy6 debug: DMA-30 0x0220 (TX) max used slots: 32/128
b43-phy6 debug: DMA-30 0x0200 (TX) max used slots: 0/128
bonding: bond0: releasing active interface wlan0
b43-phy7: Broadcom 4306 WLAN found
b43-phy7 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy7 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy7: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
bonding: bond0: Adding slave wlan0.
b43-phy7: Loading firmware version 351.126 (2006-07-29 05:54:02)
b43-phy7 warning: You are using an old firmware image. Support for old
firmware will be removed in July 2008.
b43-phy7 warning: You must go to
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and
download the latest firmware (version 4).
b43-phy7 debug: Chip initialized
b43-phy7 debug: 30-bit DMA initialized
Registered led device: b43-phy7::tx
Registered led device: b43-phy7::rx
b43-phy7 debug: Wireless interface started
b43-phy7 debug: Adding Interface type 2
bonding: bond0: enslaving wlan0 as an active interface with a down link.
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authentication with AP 00:90:d0:f2:ad:7b timed out
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
b43-phy7: Radio turned off by software
b43-phy7 debug: Removing Interface type 2
b43-phy7 debug: Wireless interface stopped
b43-phy7 debug: DMA-30 0x0200 (RX) max used slots: 1/64
b43-phy7 debug: DMA-30 0x02A0 (TX) max used slots: 0/128
b43-phy7 debug: DMA-30 0x0280 (TX) max used slots: 0/128
b43-phy7 debug: DMA-30 0x0260 (TX) max used slots: 0/128
b43-phy7 debug: DMA-30 0x0240 (TX) max used slots: 0/128
b43-phy7 debug: DMA-30 0x0220 (TX) max used slots: 32/128
b43-phy7 debug: DMA-30 0x0200 (TX) max used slots: 0/128
