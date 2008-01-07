Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34466 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYAGAGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 19:06:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: b43 will need a firmware upgrade soon
Date: Mon, 7 Jan 2008 01:05:16 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Hendrik Sattler <post@hendrik-sattler.de>,
	linux-wireless@vger.kernel.org
References: <200801061802.38297.mb@bu3sch.de> <200801070027.54717.mb@bu3sch.de> <200801070051.55678.rjw@sisk.pl>
In-Reply-To: <200801070051.55678.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <200801070105.17070.mb@bu3sch.de> (sfid-20080107_000623_859865_9A0135E0)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 January 2008 00:51:55 Rafael J. Wysocki wrote:
> On Monday, 7 of January 2008, Michael Buesch wrote:
> > On Monday 07 January 2008 00:28:15 Rafael J. Wysocki wrote:
> > > On Monday, 7 of January 2008, Michael Buesch wrote:
> > > > On Sunday 06 January 2008 23:01:00 John W. Linville wrote:
> > > > > On Sun, Jan 06, 2008 at 10:38:43PM +0100, Michael Buesch wrote:
> > > > > > On Sunday 06 January 2008 22:35:51 Pavel Roskin wrote:
> > > > > > > Quoting Michael Buesch <mb@bu3sch.de>:
> > > > > > > 
> > > > > > > > see "fwpostfix" module parameter
> > > > > > > 
> > > > > > > Can we please avoid this annoyance this time?
> > > > > > 
> > > > > > Go and complain at Broadcom please.
> > > > > 
> > > > > Broadcom doesn't really have this problem, since they are free to
> > > > > include the binary firmware in their Windows/Mac/whatever drivers.
> > > > > 
> > > > > If the driver needs different firmware, why not have it ask for
> > > > > different filenames?  As I suggested elsewhere, this could be as
> > > > > simple as setting a default value for fwpostfix...
> > > > 
> > > > I'm not sure why people are complaining about stuff that's not
> > > > done, yet. I just said that we need an update to an incompatible
> > > > firmware soon. HOW that happens is an entirely different question.
> > > > It seems like we _might_ be able to support both fw versions for some
> > > > limited time. If that is not possible for whatever reason, I will
> > > > change the fw filenames, of course. (And people will complain about
> > > > that, too. Because the rule for broadcom firmware is: Always complain
> > > > about whatever you do. ;) )
> > > > The _just_ wanted to tell people about a serious change _before_ it
> > > > happens. I'm not sure why this results in all kinds of complaints.
> > > 
> > > Most probably, because the people don't want that to happen. ;-)
> > 
> > People don't want N-PHY support?
> 
> Well, as it sometimes is said "the better is an enemy of the good".  If they
> feel comfortable without the N-PHY, why would they want it?
> 
> Still, if you can add the support for it as a feature that doesn't affect the
> people's working configurations, no one will complain.

Impossible, sorry.
We are going to add support for new firmware, which will be needed for N-PHY,
or we don't.
And I think it's clear which way we are going.
What's the problem with all of this? Other drivers change firmware to incompatible
versions on a regular basis. Look at ipw2200. There was a time when they changed
the firmware basically on every kernel release.
That wasn't a problem. Why would it be a problem here?

How the technical implementation of all that stuff works in the end
is not up to this discussion. Maybe we can support both firmware in one driver
for some limited time. Maybe we rename the firmware files once again.
I think it's likely to end up with a driver supporting 2 fw versions for a few
release cycles. But I simply can not tell you, yet.

I just wanted to tell people that a firmware change is going to happen soon.
Just informational stuff. Nothing people need to complain, suggest or argue about.

-- 
Greetings Michael.
