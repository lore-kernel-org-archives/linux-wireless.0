Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:35222 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282AbXGaPOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 11:14:17 -0400
Message-ID: <46AF51C5.6070507@warmcat.com>
Date: Tue, 31 Jul 2007 16:14:13 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <46AF4889.4070902@warmcat.com> <200707311650.34795.IvDoorn@gmail.com> <200707311706.52073.IvDoorn@gmail.com>
In-Reply-To: <200707311706.52073.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> Hi,
> 
>>>> Which version are you using?
>>>> wireless-dev <---
>>>> rt2x00.git
>>>> rt2x00 cvs
>> Ok, rt2x00.git contains many changes to the initialization of the device,
>> so it is a bit hard to compare at the moment. At least it is confirmed that rt2x00 can
>> receive all frames in monitor mode and the problem area is the DROP filter.
>>
>> I'll release rt2x00 2.0.5 later today with all those changes, including the rxdone rate
>> selection fix. So if you could retest later to see if the problem disappeared in 2.0.5 it
>> would be great. :)
> 
> Ok, that was easier then I thought, rt2x00 2.0.5 _will_ contain the fix for this.
> I just noticed that when the first and only interface is a monitor interface
> the device was not being configured at all. This has now been fixed in rt2x00.git,
> so it will be part of the 2.0.5 release later today. :)

Great, I will check for it on the serialmonkey site later and give it a go.

I just received four different kinds of cheap cards from ebuyer, I hoped
to get a bcm43xx card again but you can't choose when the cards are only
GBP8 each.  So later I will see what can happen with the other cards
that are new to me: Libertas on 88W8335 PC Card, Libertas USB stick
1286:1fab, and a Realtek PC Card RTL-8185.

Thanks to your help it looks like the first RT2571-based one is a winner ;-)

-Andy
