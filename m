Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZFVOnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 10:43:25 -0400
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Balaji Ravindran <b@w1an.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mircea Gherzan <mgherzan@gmail.com>
In-Reply-To: <87bpol90z5.fsf@litku.valot.fi>
References: <4A38672F.9090904@w1an.in> <87hbyfmlds.fsf@litku.valot.fi>
	 <1245231411.20613.3.camel@johannes.local>  <87bpol90z5.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:43:16 -0400
Message-Id: <1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-18 at 15:32 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Wed, 2009-06-17 at 09:20 +0300, Kalle Valo wrote:
> >> Balaji Ravindran <b@w1an.in> writes:
> >> 
> >> > Is anyone working on this feature enhancement(i mean wireless roaming)?
> >> > I saw it on the to-do list, and that Mircea had proposed it for GSoC. I
> >> > thought i shall dig into it, but just wanted to know if anyone's
> >> > already  being involved  and actively working  on it.
> >> 
> >> Nobody is currently working on it AFAIK. We are planning to talk about
> >> roaming at Berlin next week and I will have a brief overview to start
> >> the dicussion, but that's about it.
> >
> > Yeah, I don't think anybody is working on it.
> 
> That's my understanding as well.
> 
> > FWIW, what we need in the kernel/drivers is, I think
> >
> >  1) signals for significant signal change (offloaded to firmware for
> >     beacons while no traffic is flowing)
> 
> I agree. Also I think we need to have an user space interface to
> configure the threshold value.
> 
> >  2) a way of telling userspace whether or not it has to handle
> >  roaming, now that new cards are showing up (iwm) that can handle it
> >  themselves
> 
> What about older fullmac cards, do they support roaming in hardware?

Yes.  airo at least, and I think also atmel, orinoco, but not Libertas.
Most of the fullmac cards do handle roaming between BSSIDs in the same
SSID transparently.  Libertas on the other hand pushes that control to
the driver.

Dan

> > and probably some more. I don't suppose you will be in Berlin, but it
> > would probably be helpful for you to wait for that discussion to have
> > taken place before working on it, because then we'll have at least a
> > plan of where we want to see this go.
> 
> I agree. I'm planning to write a small report of our roaming discussion.
> Maybe we can implement this finally :)
> 

