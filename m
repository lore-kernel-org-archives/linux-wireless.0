Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:19942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXFASzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:55:06 -0400
Received: by wa-out-1112.google.com with SMTP id j4so610963wah
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 11:55:06 -0700 (PDT)
Message-ID: <5b9417770706011155q50519ecftd3e4b8114102664f@mail.gmail.com>
Date: Fri, 1 Jun 2007 13:55:06 -0500
From: "John H." <mistamaila@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Upgrade to f7 breaks bcm43xx module
Cc: "Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <5b9417770706011137q59962e95y6d810b236e6c0c3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>
	 <4660630E.7040701@lwfinger.net>
	 <5b9417770706011123s3a54c43ep69257321e8102719@mail.gmail.com>
	 <5b9417770706011137q59962e95y6d810b236e6c0c3a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I got it all fixed.  The XP installation on my system had the
file.  There is a warning that says

Warning! Idle-TSSI.... Disabling TX power adjustment.

But I assume it's nothing?  Hopefully this doesn't have the speed
problems that required a patch before.

Thanks again!



On 6/1/07, John H. <mistamaila@gmail.com> wrote:
> I mean, the correct files to populate /lib/firmware(as I assume that's
> what you mean).
>
> I don't see it, or the instructions, on
> http://bcm43xx.berlios.de/
>
> On 6/1/07, John H. <mistamaila@gmail.com> wrote:
> > Thanks for the prompt response.
> >
> > I have a dell e1505.  Do I need an updated fwcutter as well?  What is
> > the actual driver I need?  The device is broadcom 1390?
> >
> >
> > On 6/1/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> > > John H. wrote:
> > > > bcm43xx mac80211:
> > > > YOUR FIRMWARE IS TOO OLD. Firmware from binary drivers older than
> > > > version 4.x is unsupported. You must upgrade your firmware files.
> > > >
> > > > I get that now with f7 and 2.6.21 and didn't with fc6 2.6.20.
> > > >
> > > > However, I read that the error is not what it sounds like.  What is
> > > > the solution?
> > >
> > > The error is _EXACTLY_ what it sounds like. With fc6, you were using bcm43xx-softmac, which uses V3
> > > firmware. With fc7, you switched to bcm43xx-mac80211, which needs V4 firmware - just what the error
> > > message said. The solution is to download a V4 driver and create the appropriate firmware.
> > >
> > > Larry
> > >
> >
>
