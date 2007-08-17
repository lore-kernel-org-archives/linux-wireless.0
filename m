Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s28.bay0.hotmail.com ([65.54.246.228]:55161 "EHLO
	bay0-omc3-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbXHQLtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 07:49:17 -0400
Message-ID: <BAY111-F3965149B92B333B4E37A4DB6D80@phx.gbl>
In-Reply-To: <1187345926.23489.151.camel@johannes.berg>
From: "maali Al Janoob" <mms82@hotmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: question for developers (help plzz!!)
Date: Fri, 17 Aug 2007 15:49:16 +0400
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you so much for the reply. My advisor is not very convinced with this 
answer, and says that there must be somewhere a linux driver that has an 
open source firmware for protocol development purposes, or a driver that 
implements everything in software. So, firstly, can I please ask you for 
some references affirming your answer that I can include in my research? and 
secondly, are you aware of any attempt in the open source firmware 
direction?

Assuming that there is no way I can access the backoff algorithm in any of 
the commercial wireless cards, what would be the solution to my case then? I 
need to modify the backoff algorithm for my masters thesis, and if this is 
not possible with any card, what should I do?!

Thank you


>From: Johannes Berg <johannes@sipsolutions.net>
>To: maali Al Janoob <mms82@hotmail.com>
>CC: linux-wireless@vger.kernel.org
>Subject: Re: question for developers (help plzz!!)
>Date: Fri, 17 Aug 2007 12:18:46 +0200
>
>On Fri, 2007-08-17 at 00:54 +0400, maali Al Janoob wrote:
>
> > I came to know thorugh this mailing list that those two chipsets might 
>not
> > require a firmware, and that gave me hope in finding all the 802.11
> > functionalities in the open source driver codes,
>
>Heh. No, that most likely just means that the stuff was in hardware or
>the firmware is on a ROM.
>
> > Aside from this, if any one is aware of any chipset that implements ALL
> > 802.11 funcitonalities in open source software, please save me with it.
>
>Nope. I don't think there's one, it just doesn't make sense to implement
>the backoff algorithm in software because it's too timing sensitive.
>
>johannes


><< signature.asc >>

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

