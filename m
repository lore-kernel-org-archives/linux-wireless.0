Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab1CUOpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:45:06 -0400
Date: Mon, 21 Mar 2011 07:46:03 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Subject: Re: new utility kernel module for detecting cores in newer chipsets
Message-ID: <20110321144603.GA7645@kroah.com>
References: <20110319234524.GA7493@kroah.com>
 <op.vsmyhmei3ri7v4@arend-laptop>
 <20110320145421.GA13962@kroah.com>
 <op.vsnd1a1i3ri7v4@arend-laptop>
 <20110320162200.GA17030@kroah.com>
 <op.vsng7q1j3ri7v4@arend-laptop>
 <20110320185216.GD19375@kroah.com>
 <AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
 <20110321140505.GA7321@kroah.com>
 <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 03:27:49PM +0100, Rafał Miłecki wrote:
> 2011/3/21 Greg KH <greg@kroah.com>:
> > On Mon, Mar 21, 2011 at 11:12:55AM +0100, Rafał Miłecki wrote:
> >> Sorry, but you seem to be deaf to my and George's comments.
> >
> > Me?
> >
> >> What's wrong with that?
> >
> > What's wrong with what?  You provided no context in this message, so I
> > have absolutely no idea what you are referring to.
> >
> > totally confused,
> 
> Did you receive two following e-mails (in this thread):
> 1) From: Rafał Miłecki <zajec5@gmail.com>
> Date: 20 03 2011 10:55
> 2) From: George Kashperko <george@znau.edu.ua>
> Date: 20 03 2011 14:07
> ?

In digging through my archives, yes I did.

But the proper thing to do is to quote portions in which you refer to
when talking about them.  Otherwise the reciever can easily be lost.

Remember, some of us get _thousands_ of emails a day.  Remembering
context based on a subject: line is impossible, especially when the
thread is long gone from my inbox and buried in my archive.

> The case is, we discussed ssb/ai driver layout few days ago. George
> shared idea of layout I agree with, nobody shared any objections. If
> everything goes fine, we should have nicely modularized driver/project
> supporting Broadcom's buses.
> 
> In this situation I'm not really interested is simple ai driver
> stripped from brcm80211. According to me, it would led to harder
> maintenance and harder implementation of support for such a driver in
> b43.

Ok, and I trust that you and Michael will work things out.

I have no objections to what you want at all, why do you think I do?
I'm just handling getting the stuff in drivers/staging/ out of there,
that's it.  I trust the rest of you all to handle the design decisions
properly.

And as there is no code here yet to complain about, I fail to see any
problem yet :)

thanks,

greg k-h
