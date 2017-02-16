Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbraout3.email.it ([128.65.127.49]:48086 "EHLO
        zimbraout3.email.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbdBPP2y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 10:28:54 -0500
Received: from zmsend3.email.it (unknown [10.120.120.35])
        by zimbraout3.email.it (Postfix) with ESMTPS id 9568DA0C17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 16:19:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zmsend3.email.it (Postfix) with ESMTP id 7167A180E0B
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 16:19:23 +0100 (CET)
Received: from zmsend3.email.it ([127.0.0.1])
        by localhost (zmsend3.email.it [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZNU2_mT1M8Ti for <linux-wireless@vger.kernel.org>;
        Thu, 16 Feb 2017 16:19:23 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zmsend3.email.it (Postfix) with ESMTP id 16677180E16
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 16:19:23 +0100 (CET)
Received: from zmsend3.email.it ([127.0.0.1])
        by localhost (zmsend3.email.it [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RxjDKZSW9L3w for <linux-wireless@vger.kernel.org>;
        Thu, 16 Feb 2017 16:19:23 +0100 (CET)
Received: from madmax.org (host224-239-dynamic.21-79-r.retail.telecomitalia.it [79.21.239.224])
        by zmsend3.email.it (Postfix) with ESMTPSA id 9D818180E0B
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 16:19:20 +0100 (CET)
Message-ID: <58A5C340.3060201@email.it> (sfid-20170216_162858_203165_1D8E8E0E)
Date: Thu, 16 Feb 2017 16:20:32 +0100
From: madmaxxx <madmaxxx@email.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: TL-WN823N
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a problem with rtl8xxxu driver, which seems to not work with a
dongle tp-link TL-WN823N model. I just filled out a 4.9.10 kernel and the
device is not fully recognized .. I can only scan network and not link.

Thank you

lsusb:
Bus 002 Device 002: ID 2357:0109

dmesg:
[gio feb 16 16:08:33 2017] usb 2-1: Vendor: Realtek
[gio feb 16 16:08:33 2017] usb 2-1: Product: \x03802.11n NI
[gio feb 16 16:08:33 2017] usb 2-1: Serial:
[gio feb 16 16:08:33 2017] usb 2-1: rtl8192eu_parse_efuse: dumping efuse 
(0x200 bytes):
[gio feb 16 16:08:33 2017] usb 2-1: 00: 29 81 00 7c 01 40 03 00
[gio feb 16 16:08:33 2017] usb 2-1: 08: 40 74 04 50 14 00 00 00
[gio feb 16 16:08:33 2017] usb 2-1: 10: 28 28 28 29 29 29 2a 2a
[gio feb 16 16:08:33 2017] usb 2-1: 18: 2b 2b 2b f2 ef ef ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 20: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 28: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 30: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 38: ff ff 28 28 28 28 28 28
[gio feb 16 16:08:33 2017] usb 2-1: 40: 2a 2a 29 2a 2a f2 ef ef
[gio feb 16 16:08:33 2017] usb 2-1: 48: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 50: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 58: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 60: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 68: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 70: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 78: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 80: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 88: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 90: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 98: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: a0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: a8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: b0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: b8: a1 22 21 00 00 00 ff ff
[gio feb 16 16:08:33 2017] usb 2-1: c0: ff 01 00 10 00 00 00 ff
[gio feb 16 16:08:33 2017] usb 2-1: c8: 00 00 ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: d0: 57 23 09 01 e7 47 02 98
[gio feb 16 16:08:33 2017] usb 2-1: d8: de d0 1e a4 d7 0a 03 52
[gio feb 16 16:08:33 2017] usb 2-1: e0: 65 61 6c 74 65 6b 20 0e
[gio feb 16 16:08:33 2017] usb 2-1: e8: 03 38 30 32 2e 31 31 6e
[gio feb 16 16:08:33 2017] usb 2-1: f0: 20 4e 49 43 20 00 00 ff
[gio feb 16 16:08:33 2017] usb 2-1: f8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 100: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 108: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 110: ff ff ff ff ff ff ff 0d
[gio feb 16 16:08:33 2017] usb 2-1: 118: 03 00 05 00 30 00 00 00
[gio feb 16 16:08:33 2017] usb 2-1: 120: 00 93 ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 128: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 130: f6 a8 98 2d 03 92 98 00
[gio feb 16 16:08:33 2017] usb 2-1: 138: fc 8c 00 11 9b 44 02 0a
[gio feb 16 16:08:33 2017] usb 2-1: 140: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 148: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 150: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 158: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 160: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 168: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 170: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 178: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 180: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 188: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 190: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 198: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1a0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1a8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1b0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1b8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1c0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1c8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1d0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1d8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1e0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1e8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1f0: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: 1f8: ff ff ff ff ff ff ff ff
[gio feb 16 16:08:33 2017] usb 2-1: RTL8192EU rev B (SMIC) 2T2R, TX 
queues 3, WiFi=1, BT=0, GPS=0, HI PA=0
[gio feb 16 16:08:33 2017] usb 2-1: RTL8192EU MAC: 98:de:d0:1e:a4:d7
[gio feb 16 16:08:33 2017] usb 2-1: rtl8xxxu: Loading firmware 
rtlwifi/rtl8192eu_nic.bin
