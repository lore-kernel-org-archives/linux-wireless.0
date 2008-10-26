Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr02-03.mta.terra.com.br ([200.154.152.32]:59850 "EHLO
	sr02-03.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJZHfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 03:35:20 -0400
Received: from temora.hst.terra.com.br (terra-v-262-bsw-03-04-poa.tc.terra.com.br [200.176.10.6])
	by bundure.hst.terra.com.br (Postfix) with ESMTP id 5D48D1C00022F
	for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 07:35:15 +0000 (UTC)
Received: from [192.168.0.7] (bd2180d5.virtua.com.br [189.33.128.213])
	(authenticated user piterpk)
	by temora.hst.terra.com.br (Postfix) with ESMTP id 3A1D93000149
	for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 07:35:14 +0000 (UTC)
Message-ID: <49041DAE.1060206@terra.com.br> (sfid-20081026_083539_512848_C59529A4)
Date: Sun, 26 Oct 2008 05:35:10 -0200
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I did some new tests to see what's my transmission problems with
rtl8187b. I can associate and can send pings (and even to connect
through ssh with other hosts) but i can't transmit "big" files. But
at first mail I didn't know how big must be a "big" file.

I tested with 64, 128, 256, 512, 1024 and 2048 bytes files. From 64 to
512 I always can transmit the file. 1024 sometimes hangs and 2048
always hangs. All files can be transmitted using rt73usb wireless.

I put the tcpdump output of those tests in:

http://www.slackware.com/~piterpunk/transmittests/

The 512-byte file dump is almost equal for both wireless cards.
2048-byte is very different. All logs are scp from my machine to
slackware.com. But the same happens sending mail (but not receiving),
uploading ftp files, doing scp to other machines, etc...

I'll be very happy to provide any extra information or do additional
tests with the cards to help the problem diagnostics. Changing the
rate didn't have any influence in test results. I have an iwl3945 that
works fine, too.

Thanks in advance!

Piter PUNK
-- 
     |        E-Mail: piterpk@terra.com.br
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^         ----> Slackware Linux <----
  #105432
