Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752756AbYJ1WtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 18:49:25 -0400
Date: Tue, 28 Oct 2008 15:45:35 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Thorsten Leemhuis <fedora@leemhuis.info>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
Message-ID: <20081028224535.GA27948@kroah.com> (sfid-20081028_234931_199267_09E99927)
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info> <1225180598.3796.66.camel@johannes.berg> <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com> <1225181562.3796.76.camel@johannes.berg> <20081028170838.GA4818@kroah.com> <1225218952.3598.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225218952.3598.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 07:35:52PM +0100, Johannes Berg wrote:
> On Tue, 2008-10-28 at 10:08 -0700, Greg KH wrote:
> 
> > "Work on", or "USE".
> > 
> > The problem is, users have this hardware, and they want to run Linux on
> > it.  Many distros already support this hardware with the "crap" driver,
> > so we might as well add that to the kernel tree so they at least get the
> > latest "crap" so that users have an easier time of it.
> > 
> > Now, the fact that there is a competing driver being developed outside
> > of the tree does make this a bit more complicated.  However, as it
> > doesn't work yet, there's not much we can do about including it, right?
> > 
> > So adding the driver to the "crap" tree makes users happy in that they
> > can use their hardware.  I'll support the "crap" to a point, and no one
> > has to do any API changes to the drivers/staging/ tree either, I can
> > easily handle that.
> > 
> > Then, when the "correct" driver is finished, I will drop the crap driver
> > at the same time the "correct" one is added to the tree.
> > 
> > This way, everyone wins, right?
> 
> Only if the point is "use" rather than "work on". As far as I understood
> about staging, the point was more "work on" which would direct effort to
> the wrong driver.

I'm not going to turn away patches that people send me to get the stable
drivers cleaned up and in better shape.

I've now added the rtl2860 driver to the staging tree with a big note
that any comments should be made to me only, and that the wireless
developers would really have people work on their driver instead to get
it into a mergable state.

It can be found at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/staging-add-rtl2860-wireless-driver.patch
if anyone wants to review it before I send it to Linus.

thanks,

greg k-h
