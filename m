Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbYCESTq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:19:46 -0500
Subject: Re: B43 will not associate
From: Dan Williams <dcbw@redhat.com>
To: Ahmed Ammar <b33fc0d3@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <84ac67910803050734t1386a8edx39eb7133c909d9bb@mail.gmail.com>
References: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com>
	 <200803042047.35710.mb@bu3sch.de>
	 <84ac67910803041413s510c5513k25f77762b0e70d@mail.gmail.com>
	 <200803051517.31919.mb@bu3sch.de>
	 <84ac67910803050734t1386a8edx39eb7133c909d9bb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 13:16:40 -0500
Message-Id: <1204741000.9378.6.camel@localhost.localdomain> (sfid-20080305_181953_666494_4F88D03E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-05 at 15:34 +0000, Ahmed Ammar wrote:
> >  It's impossible to debug something, if you don't fscking
> >  tell me your testbed setup and what's going on/wrong.
> 
> Well you don't get what you don't ask for.
> 
> I assume testbed means my hardware.
> 
> x86_64 proc., runnig 2.6.24-rt3 (in 64bit) with gentoo userland
> (64bit). The card in question is a pci card.
> 
> I have tried on 2.6.24 vanilla and the association problem is exactly
> the same. The card can see the AP fine but simply won't associate, as
> you can see in the previous dmesg (wlan1). The capture is was to see
> what packets the b43 driver is sending. I was asked to do this by
> Johannes Berg.

I think Michael was also looking for stuff like your wireless cards.
Kind of pointless to post about your hardware when you exclude the
wireless hardware you're using and the problem you're having is
wireless-related.

1) What's your wlan0?  What driver is it using?
2) What's your wlan1?  What driver is it using?
3) Which interface are you having problems on?

Personally, I was somewhat confused because you (I think) said you were
having problems with _wlan1_, but you referenced wlan0 in other mails.

Dan


