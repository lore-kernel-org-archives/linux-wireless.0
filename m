Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59577 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1AOPtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 10:49:13 -0500
Received: by ywl5 with SMTP id 5so1219390ywl.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 07:49:12 -0800 (PST)
Message-ID: <4D31C1F5.7080306@whoplays.asia>
Date: Sun, 16 Jan 2011 00:49:09 +0900
From: "u2@whoplays.asia" <u2@whoplays.asia>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [Driver] NEC WL300NU-G
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

According to the list linuxwireless.org/en/users/Devices/USB, Wireless 
USB adapter NEC WL300NU-G[0x409:0x093f] is supported by ar9170usb.

But the one I bought via 
www.amazon.co.jp/NEC-Aterm-WL300NU-G-PA-WL300NU-G is [0x409:0x0249] and 
not detected by any drivers...

$ lsusb
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 006: ID 0a5c:2101 Broadcom Corp. Bluetooth Controller
Bus 002 Device 005: ID 0853:0100 Topre Corporation HHKB Professional
Bus 002 Device 004: ID 0409:005a NEC Corp. HighSpeed Hub
Bus 002 Device 003: ID 0409:0249 NEC Corp.
Bus 002 Device 002: ID 2019:ab50 PLANEX GW-US54Mini2
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
$ uname -a
Linux localhost 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 
x86_64 GNU/Linux

Plz anyone describe me why this one has another vendor-productID, and 
will this one supported?

Regards,
Miyagi
