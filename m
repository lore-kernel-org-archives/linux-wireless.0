Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52228 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZDONaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 09:30:52 -0400
Date: Wed, 15 Apr 2009 09:19:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090415131929.GB21411@tuxdriver.com> (sfid-20090415_153057_359230_C9BA7C05)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090414141852.GB20470@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2009 at 10:19:06AM -0400, Forest Bond wrote:
> On Tue, Apr 14, 2009 at 09:02:48AM -0400, John W. Linville wrote:

> > None of the above is meant to disagree about the staging crap.
> > Having that stuff around is at best an optimistic attempt to help a
> > few stray users... :-)
> 
> Well, gosh, I understand the criticism here and if I were a kernel developer I
> imagine my perspective would be much the same.  But I can't help but feel that
> there's some amount of hypocrisy when we hammer on a manufacturer to properly
> license their driver and then let it drop dead when they do.

Proper licensing is a prerequisite, not the final objective.

> I understand that the problem would be solved if they manufacturers would
> suddenly "get it," but the scale of social problem preventing that is likely too
> large to change anytime soon.
> 
> If kernel developers are too busy to support the hardware, why do the
> manufacturers take so much criticism for releasing binary-only drivers or badly
> licensed drivers, or for neglecting to release technical specifications?  If
> what I'm sensing is correct and there's no practical likelihood of these devices
> getting in-kernel support even with those issues resolved, the criticism almost
> seems unjustified.

Swimming with the red fishes..."next to no support" may be infinitely
greater than "no support", but it still is only a first step.
It amounts to throwing something over the wall and walking away.

Most kernel developers have neither financial nor personal interest
in supporting hardware they don't have in their possession.  Some may
still lack both of those for random hardware in their collection.
A vendor choosing to take a minimal step towards the community does
not obligate us to take great leaps in their direction, especially
not at our own expense of time or money.

> I appreciate what the kernel developers do, of course, and my intention is not
> to ruffle feathers.  But when a manufacturer that has taken a lot of criticism
> for its approach to the Linux community shows some good will, it seems like we
> ought to be able to turn that into something productive.  If we can't, what have
> we been complaining about?

I would love to see this hardware properly supported in the kernel.
I sincerely hope someone finds the time to do something positive
with it.  But as it stands neither I nor any of the other known
wireless developers have infinite time to support a driver for hardware
that none of us has -- especially not simply out of the goodness of
our hearts.  I'm sorry, but that is just the way it is.
 
> My apologies if I'm way off on this.  I haven't been around all that long so it
> is certainly possible.

Greg has provided drivers/staging as a compromise.  I'm sorry if some
of the comments seem too harsh, but I think there is room for both
positive and negative opinions about drivers/staging.  If anything,
I'm a bit neutral about it -- I think it helps some users but is
probably a net demotivator for development of proper drivers.

Hth...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
