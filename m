Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52334 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753789AbYJ1SUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:20:23 -0400
Date: Tue, 28 Oct 2008 10:10:24 -0700
From: Greg KH <greg@kroah.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Thorsten Leemhuis <fedora@leemhuis.info>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
Message-ID: <20081028171024.GC4818@kroah.com> (sfid-20081028_192030_069023_1CA15134)
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info> <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 07:48:54AM +0000, Luis Correia wrote:
> Hi!
> 
> On Tue, Oct 28, 2008 at 07:03, Thorsten Leemhuis <fedora@leemhuis.info> wrote:
> > On 28.10.2008 01:49, Greg KH wrote:
> >>
> >> So, on my quest to suck up every out-of-tree driver and get it into the
> >> main kernel tree (drivers/staging/ to start with), I've been pointed at
> >> the rtl2860 driver.
> >
> > Does it really make sense to include a driver when a different one for
> > mainline inclusion is being actively developed? It might give some
> > developers the impression that it's worth spending time improving the
> > rtl2860/2870 drivers -- which might be wasted time in the end.
> 
> Is it just me or you are suggesting we use the Ralink supplied driver,
> with its own wireless stack, rather then work with the rt2x00 team?

No, See my other post in this thread about what I am suggesting.

> Do we really want that again (several wireless stacks)?

We already have that in the "crap" tree today (see drivers/staging/) :)

thanks,

greg k-h
