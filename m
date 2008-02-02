Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:50384 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYBBOh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 09:37:28 -0500
Received: by py-out-1112.google.com with SMTP id u52so2200581pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 06:37:27 -0800 (PST)
To: Adam Turk <bofh1234@hotmail.com>
Subject: Re: rt73 driver doesn't work in 2.6.24
Date: Sat, 2 Feb 2008 15:36:50 +0100
Cc: linux-wireless@vger.kernel.org
References: <BAY101-W12F4D19DA27A5DA9F177E1C8310@phx.gbl>
In-Reply-To: <BAY101-W12F4D19DA27A5DA9F177E1C8310@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802021536.50534.IvDoorn@gmail.com> (sfid-20080202_143741_728478_52F40637)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I was rather pleased to see that my Edimax ew7318usg was supported by mainline.  I created a new config, compiled, (no errors), and rebooted with the wireless card plugged in and I get errors on module load. Here is the output from dmesg:
> 
> rt73usb 1-1:1.0: usb_probe_interface
> rt73usb 1-1:1.0: usb_probe_interface - got id
> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
> phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x0000
> phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
> phy0: Selected rate control algorithm 'simple'
> phy0: Failed to initialize wep

This is a problem with mac80211 loading the wep encryption, did you load the arc4 module?

Ivo
