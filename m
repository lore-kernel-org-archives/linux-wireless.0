Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:20637 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYFBRtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:49:06 -0400
Received: by py-out-1112.google.com with SMTP id p76so497660pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 10:49:05 -0700 (PDT)
Message-ID: <1deddf2e0806021049tff1b11fscd012f7794ec48b0@mail.gmail.com> (sfid-20080602_194910_679958_C7AC2BE4)
Date: Mon, 2 Jun 2008 10:49:04 -0700
From: "Ryan Loebs" <obsidianx@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Broadcom 4311 and Master Mode
In-Reply-To: <1212428650.3599.6.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1deddf2e0806021023j156ff226n98838622ad77ea9d@mail.gmail.com>
	 <1212428650.3599.6.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alright, I had it set to hw_mode=b changed it to hw_mode=g and now it
got through... somewhat...

Now  I get this:

Upon startup:
=========================================
Configuration file: hostapd.conf
Failed to update rate sets in kernel module
Could not set passive scanning: Unknown error 4294967295
Mode: IEEE 802.11g  Channel: 5  Frequency: 2432 MHz
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
Using interface wlan0 with hwaddr 00:1a:73:a4:44:c8 and ssid 'test'
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
unknown mgmt cb frame subtype 4
=========================================


Nintendo DS attempts to connect and test:
=========================================
wlan0: STA 00:09:bf:63:d9:79 IEEE 802.11: authenticated
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
wlan0: STA 00:09:bf:63:d9:79 IEEE 802.11: associated (aid 1,
accounting session 484431D2-00000000)
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
^CSignal 2 received - terminating
=========================================
