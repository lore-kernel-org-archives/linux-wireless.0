Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35953 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2LIQD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 11:03:57 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so728880wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Dec 2012 08:03:56 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 9 Dec 2012 22:03:55 +0600
Message-ID: <CAJeN2nsAtS_v6amDnWhbGQURmNeca0L0k_3icjzCYnKk2PweaQ@mail.gmail.com> (sfid-20121209_170436_369575_C2E36EF0)
Subject: Question about rtl8188RU chipset.
From: =?KOI8-R?B?5M3J1NLJyiD21dbHz9c=?= <ramzeth@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.
I have a problem using ALFA AWUS036nhr card, with rtl8188RU chipset in
BackTrack R3, with best suitable (as posted on forums) compat-wireless
driver for rtl8192CU chipset.
Problems are following:
1. Airodump-ng , shows that all clients are "no assocciated".
2. Can't change TX power above 20dBm even in BO region.
3. Can't connect to AP with WPA using WiCd, because "bad password".
4. When using WireShark i can't any "Probe Response" frame.

Looking at WEB i've found many similar issues:
http://www.backtrack-linux.org/forums/showthread.php?t=45323&highlight=awus036nhr
http://hezik.nl/alfa-awus036nhr-chip-rtl8188ru-compat-wireless-driver-install/#
http://forum.aircrack-ng.org/index.php?topic=14146.0
http://forum.aircrack-ng.org/index.php?topic=11543.30


Can you explain me about supporting this chipset, who can I contact
and what can i do to solve this problem ?

Best Regards
Zhuzhgov Dmitriy.
