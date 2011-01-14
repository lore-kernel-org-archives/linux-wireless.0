Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46420 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1ANRjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 12:39:19 -0500
Received: by eye27 with SMTP id 27so1552461eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 09:39:18 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 09:39:18 -0800
Message-ID: <AANLkTinc0UxPq+Wyt0P9RRNKyEXswitzHGiruwTvbg1L@mail.gmail.com>
Subject: Why multiple ESSIDS in one CELL
From: y bhanu <kernelccrazy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to scan to scan for my under-test Access Point from a ubuntu client.
It shows me multiple ESSIDs in a a single cell and also it marks the
Mode "Unknown/bug".
Any clues why this is happening?

                   ESSID:"Atheros_XSpan_2G"

ESSID:"\x06\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
                   Mode:Unknown/bug

         Cell 06 - Address: 00:00:83:31:25:33
                   Channel:6
                   Frequency:2.437 GHz (Channel 6)
                   Quality=70/70  Signal level=-31 dBm
                   Encryption key:off
                   ESSID:"Atheros_XSpan_2G"
                   Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                             9 Mb/s; 12 Mb/s; 18 Mb/s
                   Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s

ESSID:"\x06\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
                   Mode:Unknown/bug
                   Extra:tsf=0000000001eadf50
                   Extra: Last beacon: 13748ms ago
                   IE: Unknown: 001041746865726F735F585370616E5F3247
                   IE: Unknown: 010882848B960C121824
                   IE: Unknown: 030106
                   IE: Unknown: 0706555320010B1B
                   IE: Unknown: 200100
                   IE: Unknown: 2A0100
                   IE: Unknown: 32043048606C
                   IE: Unknown:
2D1A0C001BFFFF000000000000000000000000000000000000000000
                   IE: Unknown:
331A0C001BFFFF000000000000000000000000000000000000000000
                   IE: Unknown:
3D1606080000000000000000000000000000000000000000
                   IE: Unknown:
341606080000000000000000000000000000000000000000
                   IE: Unknown: 4A0E14000A002C01C800140005001900
                   IE: Unknown: 7F0101
                   IE: Unknown:
DD180050F2020101810003A4000027A4000042435E0062322F00
                   IE: Unknown: DD0900037F01010000FF7F
Thanks
bhanu
