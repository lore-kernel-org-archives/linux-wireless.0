Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:58879 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZAANod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 08:44:33 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LINqY-0004wk-Nb
	for linux-wireless@vger.kernel.org; Thu, 01 Jan 2009 14:44:22 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
Date: Thu, 1 Jan 2009 14:44:20 +0100
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901011444.20333.listsrv@wilsoft.nl> (sfid-20090101_144436_679942_B874B17A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j <at> w1.fi> writes:

> I've never tested this with compat-wireless, but the wireless-testing
> version seems to be working fine in my tests.
> 
> > I have build the kernel, compiled the compat-wireless and did a make 
install.
> > Make unload didnt work because some drivers were in use (mac80211).
> > First problem arises, a rmmod ath9k hangs the kernel. No message of what 
so 
> > ever in the log or to stdout.
> 
> Would you happen to have another host available for storing the logs? I
> have been able to receive debug messages from most crashes with
> netconsole (see Documentation/networking/netconsole.txt).
> 

I have tested on the server  with the latest wireless-testing the past days 
(2.6.28-rc9-wl). The wireless-testing looks somewhat more stable then the 
compat-wireless. 

I have also installed the netconsole module to watch any kernel prints. After 
running hostapd (v0.6.6) from command line the AP is up-and-running. Then if I 
connect with the laptop (tested it with kernel .26 and .28 on the laptop) I 
get a connection and can start a browser en explore the internet. If I start 
a second session (Kmail or second browser) the 
server hangs within a minute. Leaving again no trace on the console, 
hostapd-log or netconsole.
Only way to reset the server is switch off the power.
Its very frustrating because no information or what so ever can be found.

If I connect an internet radio (Musicpal) to the server there is no problem. 
It stays stable for hours. If I also connect the laptop and start a browser 
the server hangs again within minuts.

Its looks like if there is a second connection been set up the server hangs.

Anyone any clue how to investigate this??

Thanks,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

