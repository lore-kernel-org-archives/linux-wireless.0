Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ccsrelay01.in2p3.fr ([134.158.66.51]:45854 "EHLO
	ccsrelay01.in2p3.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYDRNQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 09:16:32 -0400
Received: from apcnb28.in2p3.fr (apcnb28.in2p3.fr [134.158.184.116])
	by ccsrelay01.in2p3.fr (8.14.2/8.14.2/IN2P3) with ESMTP id m3ICp8t6013702
	for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 14:51:08 +0200
Received: from frenkiel by apcnb28.in2p3.fr with esmtp (masqmail
 0.2.21) id 1Jmq3U-4Qs-00 for <linux-wireless@vger.kernel.org>; Fri, 18
 Apr 2008 14:51:04 +0200
Date: Fri, 18 Apr 2008 14:51:04 +0200 (CEST)
From: Pierre Frenkiel <pierre.frenkiel@apc.univ-paris7.fr>
To: linux-wireless@vger.kernel.org
Subject: ath5k phy0: noise floor calibration timeout 
Message-ID: <Pine.LNX.4.64.0804181435480.16108@apcnb28.in2p3.fr> (sfid-20080418_141634_753355_B12A449E)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,
I have a 3-com PCCARD, with the AR5413 chipset
I installed 2 days ago compat-wireless-2.6.tar.bz2, on Ubuntu Gutsy,
and everything seemed to work.
I just had in the log 2 or 3 messages:

    ath5k phy0: noise floor calibration timeout

but yesterday, when rebooting, I got a huge number of such messages(more
than 100 in the log file), with also

    ath5k phy0: ath5k_chan_set: unable to reset channel
    ath0: failed to set freq to 2422 MHz for scan
    ath0: failed to restore operational channel after scan

and the boot froze. I then removed my PCCARD,
and after poweroff/poweron, I could boot normally.

It seems to be fixed now, as I have no more this problem after
re-inserting the card. 
But as I did nothing, I would like to know what might happen: 
If this happened once, there is no reason why this would not happen an
other time.

Pierre
