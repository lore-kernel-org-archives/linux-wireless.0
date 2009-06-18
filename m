Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:34763 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZFRMcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 08:32:16 -0400
Received: by fxm8 with SMTP id 8so1000534fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 05:32:18 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Balaji Ravindran <b@w1an.in>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
References: <4A38672F.9090904@w1an.in> <87hbyfmlds.fsf@litku.valot.fi>
	<1245231411.20613.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 18 Jun 2009 15:32:14 +0300
In-Reply-To: <1245231411.20613.3.camel@johannes.local> (Johannes Berg's message of "Wed\, 17 Jun 2009 11\:36\:51 +0200")
Message-ID: <87bpol90z5.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-06-17 at 09:20 +0300, Kalle Valo wrote:
>> Balaji Ravindran <b@w1an.in> writes:
>> 
>> > Is anyone working on this feature enhancement(i mean wireless roaming)?
>> > I saw it on the to-do list, and that Mircea had proposed it for GSoC. I
>> > thought i shall dig into it, but just wanted to know if anyone's
>> > already  being involved  and actively working  on it.
>> 
>> Nobody is currently working on it AFAIK. We are planning to talk about
>> roaming at Berlin next week and I will have a brief overview to start
>> the dicussion, but that's about it.
>
> Yeah, I don't think anybody is working on it.

That's my understanding as well.

> FWIW, what we need in the kernel/drivers is, I think
>
>  1) signals for significant signal change (offloaded to firmware for
>     beacons while no traffic is flowing)

I agree. Also I think we need to have an user space interface to
configure the threshold value.

>  2) a way of telling userspace whether or not it has to handle
>  roaming, now that new cards are showing up (iwm) that can handle it
>  themselves

What about older fullmac cards, do they support roaming in hardware?

> and probably some more. I don't suppose you will be in Berlin, but it
> would probably be helpful for you to wait for that discussion to have
> taken place before working on it, because then we'll have at least a
> plan of where we want to see this go.

I agree. I'm planning to write a small report of our roaming discussion.
Maybe we can implement this finally :)

-- 
Kalle Valo
