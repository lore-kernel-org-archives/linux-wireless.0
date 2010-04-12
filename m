Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64341 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0DLKAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 06:00:30 -0400
Received: by ewy20 with SMTP id 20so1859925ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 03:00:29 -0700 (PDT)
Message-ID: <4BC2EF3B.2060902@gmail.com>
Date: Mon, 12 Apr 2010 12:00:27 +0200
From: =?windows-1252?Q?Torquil_Macdonald_S=F8rensen?= <torquil@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k compilation error
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I hope this is the right place to report this. If not, I would appreciate 
directions to the correct mailing list. In that case, sorry for spamming! :-)

I'm getting an error when compiling the ath9k driver in 
compat-wireless-2010-04-11. The version 2010-04-04 compiles fine after fixing a 
simple

First I do:

./scripts/driver-select ath9k

The I run "make", and after some time I get the following:

   CC [M]  /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o
/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c: In function 
‘ieee80211_alloc_hw’:
/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c:394: error: 
implicit declaration of function ‘__hw_addr_init’
make[5]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o] Error 1
make[4]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211] Error 2
make[3]: *** [_module_/home/tmac/src/compat-wireless-2010-04-11] Error 2
make[2]: *** [sub-make] Error 2


I want to try the newest driver because I have a lot of dropout problems when 
using my "Atheros Communications Inc. AR9285 Wireless Network Adapter 
(PCI-Express) (rev 01)"

gcc (Debian 4.4.3-7) 4.4.3

Best regards
Torquil Sørensen
