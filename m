Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp30.kymp.net ([80.248.96.181]:2960 "EHLO smtp.kymp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab1DFOUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:20:16 -0400
Message-ID: <4D9C764E.2040107@saunalahti.fi>
Date: Wed, 06 Apr 2011 17:18:54 +0300
From: Kimmo Huoso <kimmo.huoso@saunalahti.fi>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB Adapter(rev.A)
 [Atheros AR9001U-(2)NG] Invalid misc and Tx excessive retries
References: <4D9B077E.3090106@saunalahti.fi> <201104061438.43678.chunkeey@googlemail.com>
In-Reply-To: <201104061438.43678.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for answering.

Im trying now to get the carl9170 debug working. I didnt see any 
parameter for debug while running modinfo carl9170. But some sort of 
debug code seems to be in place in compat-wireless under carl9170. What 
should i do to enable it. And second how can i get readings from 
/sys/kernel/debug to be exact. I dont know much of what comes to kernel 
debugging. And for third even the softmac numbers/statistics might be 
bogus, im still having problems with the driver while trying to run 
programs that are strict for smooth connection like online games.

The card is 7d1:3c10 which has been marked as Rev.A1 and sticker at the 
back says so too.

Thanks Kimmo

06.04.2011 15:38, Christian Lamparter kirjoitti:
> On Tuesday 05 April 2011 14:13:50 Kimmo Huoso wrote:
>> Im having vast amount of  Invalid misc, Tx excessive retries. my
>> hardware is 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB
>> Adapter(rev.A) [Atheros AR9001U-(2)NG].
> There are two "rev A", hope you got the second revision.
>
> But back to the topic: these softmac numbers/statistics are bogus...
> It might sound a bit weird, but in fact they are not high enough.
>
> To make a fair comparison you would have to check the hardware
> counters [RX_PHY_MISC_ERROR&  friends] instead. carl9170 already
> has a debugfs interface for this reason [hw_[r|t]x_tally], but
> ar9170usb lacks this feature.
>
> Regards,
> 	Chr
>

