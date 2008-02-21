Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:43274 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYBUUEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 15:04:31 -0500
Received: by wr-out-0506.google.com with SMTP id c48so249382wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 12:04:29 -0800 (PST)
Message-ID: <84ac67910802211204y575e893cnd056bbd7442f27ea@mail.gmail.com> (sfid-20080221_200435_903590_0D1B8D60)
Date: Thu, 21 Feb 2008 20:04:28 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: b43 (H/W 4306 Rev. 03)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080221182615.GK3094@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
	 <20080221163134.GF3094@tuxdriver.com>
	 <84ac67910802211007n55569d6j92dee1da198e9b1d@mail.gmail.com>
	 <20080221182615.GK3094@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
>
>
> You are still using the same firmware.
>
>  Make sure you extracted the firmware to the right place.  You may have
>  to use the "-w" option to b43-fwcutter.  The proper firmware location
>  depends on the distribution.  For Fedora it is in /lib/firmware.
>

I am very sure. Do I need to reboot?  All I did was: rmmod b43 ssb

b33fb0x firmware # rm -rf b43
b33fb0x firmware # b43-fwcutter --unsupported
/usr/src/broadcom-wl-4.80.53.0/kmod/wl_apsta_mimo.o
This file is recognised as:
  filename   :  wl_apsta_mimo.o
  version    :  351.126
  MD5        :  722e2e0d8cc04b8f118bb5afe6829ff9
Extracting b43/ucode4.fw
Extracting b43/ucode5.fw
Extracting b43/ucode11.fw
Extracting b43/ucode13.fw
Extracting b43/pcm4.fw
Extracting b43/pcm5.fw
Extracting b43/b0g0initvals4.fw
Extracting b43/b0g0bsinitvals4.fw
Extracting b43/a0g0initvals4.fw
Extracting b43/a0g0bsinitvals4.fw
Extracting b43/b0g0initvals5.fw
Extracting b43/b0g0bsinitvals5.fw
Extracting b43/a0g0initvals5.fw
Extracting b43/a0g1initvals5.fw
Extracting b43/a0g0bsinitvals5.fw
Extracting b43/a0g1bsinitvals5.fw
Extracting b43/lp0initvals13.fw
Extracting b43/lp0bsinitvals13.fw
Extracting b43/b0g0initvals13.fw
Extracting b43/b0g0bsinitvals13.fw
Extracting b43/a0g1initvals13.fw
Extracting b43/a0g1bsinitvals13.fw
b33fb0x firmware # pwd
/lib/firmware
b33fb0x firmware # ls
b43  b43legacy  rt2561.bin  rt2561s.bin  rt2661.bin
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
b43-phy8: Broadcom 4306 WLAN found
b43-phy8 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy8 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy8: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
bonding: bond0: Adding slave wlan0.
b43-phy8: Loading firmware version 351.126 (2006-07-29 05:54:02)
b43-phy8 warning: You are using an old firmware image. Support for old
firmware will be removed in July 2008.
b43-phy8 warning: You must go to
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and
download the latest firmware (version 4).
b43-phy8 debug: Chip initialized
b43-phy8 debug: 30-bit DMA initialized
Registered led device: b43-phy8::tx
Registered led device: b43-phy8::rx
b43-phy8 debug: Wireless interface started
b43-phy8 debug: Adding Interface type 2
bonding: bond0: enslaving wlan0 as an active interface with a down link.
b43-phy8 debug: Using hardware based encryption for keyidx: 0, mac:
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
b43-phy8: Radio turned off by software
b43-phy8 debug: Disabling hardware based encryption for keyidx: 0,
mac: ff:ff:ff:ff:ff:ff
b43-phy8 debug: Removing Interface type 2
b43-phy8 debug: Wireless interface stopped
b43-phy8 debug: DMA-30 0x0200 (RX) max used slots: 1/64
b43-phy8 debug: DMA-30 0x02A0 (TX) max used slots: 0/128
b43-phy8 debug: DMA-30 0x0280 (TX) max used slots: 0/128
b43-phy8 debug: DMA-30 0x0260 (TX) max used slots: 0/128
b43-phy8 debug: DMA-30 0x0240 (TX) max used slots: 0/128
b43-phy8 debug: DMA-30 0x0220 (TX) max used slots: 32/128
b43-phy8 debug: DMA-30 0x0200 (TX) max used slots: 0/128
