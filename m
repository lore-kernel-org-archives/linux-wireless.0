Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54029 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZFLAGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 20:06:08 -0400
Subject: Re: rfkill on T61
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890906111659h7649529dobf20b937661da8aa@mail.gmail.com>
References: <43e72e890906111559p614e83fdnec245fb806e01fc3@mail.gmail.com>
	 <1244763159.27363.103.camel@violet>
	 <43e72e890906111659h7649529dobf20b937661da8aa@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 02:06:07 +0200
Message-Id: <1244765167.27395.1.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> >> When I hit rfkill, I get:
> >>
> >> [18493.777231] btusb_intr_complete: hci0 urb cbe20000 failed to resubmit (19)
> >> [18493.777553] btusb_send_frame: hci0 urb f7d3c700 submission failed
> >>
> >> When I hit it again I get:
> >>
> >> [18531.488091] usb 1-1: new full speed USB device using uhci_hcd and address 7
> >> [18531.651409] usb 1-1: configuration #1 chosen from 1 choice
> >>
> >> The device that disappears upon rfkill is my bluetooth controller:
> >>
> >> mcgrof@tesla ~ $ diff -u before-rfkill after-rfkill
> >> --- 1   2009-06-11 15:37:37.000000000 -0700
> >> +++ 2   2009-06-11 15:37:49.000000000 -0700
> >> @@ -6,7 +6,6 @@
> >>  Bus 003 Device 004: ID 046d:c040 Logitech, Inc. Corded Tilt-Wheel Mouse
> >>  Bus 003 Device 003: ID 04b3:4485 IBM Corp.
> >>  Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> >> -Bus 001 Device 006: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
> >>  Bus 001 Device 004: ID 0483:2016 SGS Thomson Microelectronics
> >> Fingerprint Reader
> >>  Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >>  Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> >>
> >> Granted I tested this on 2.6.27 with bleeding edge compat-wireless but
> >> I think this is the same behaviour I will get with bleeding edge, will
> >> try now on wireless-testing.
> >
> > what are you trying to tell us.
> 
> my 802.11 device is not rfkill'ed on the T61, some patches recently
> went in to add support for rfkill on ath5k. I do have thinkpad_acpi
> loaded on this ancient 2.6.27 kernel.
> 
> I'll try on wireless-testing next, build is almost done.

still are not getting what you wanna tell us. What has Bluetooh RFKILL
switch to do with WiFi. With an updated mac80211/cfg80211 the soft kill
should work for every mac80211 based driver. Works for me with iwlwifi
in my X200.

Regards

Marcel


