Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:46198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275AbXKTXJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 18:09:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Wed, 21 Nov 2007 00:26:48 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20071119202121.6ad3fa70@morte> <200711192357.44407.rjw@sisk.pl> <200711201509.55763.mb@bu3sch.de>
In-Reply-To: <200711201509.55763.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711210026.49732.rjw@sisk.pl> (sfid-20071120_230933_106116_B96B4700)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 20 of November 2007, Michael Buesch wrote:
> On Monday 19 November 2007 23:57:43 Rafael J. Wysocki wrote:
> > > Having both drivers in 2.6.24 should help find out if 
> > > there's anything which should be ironed out with b43/b43legacy, but right
> > > now they are already working a lot better than bcm43xx, and they are more
> > > stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> > > 2.6.25.
> > 
> > Many people use the old driver and you are forcing them to switch in a rather
> > unfriendly fashion.
> > 
> > Moreover, the switch generally involves a configuration change (on my system
> > eth1 became wlan0) and is not _that_ seamless.
> > 
> > IMvHO, the schedule of the removal of this driver should be discussed on LKML.
> 
> Ok, so we are going to add Rafael J. Wysocki as the bcm43xx maintainer
> and remove everyone else. I'm OK with that.

[That wasn't nice.]

I'm not qualified to maintain that code, sorry.  Apart from this, I've switched
to b43. :-)

> It is known for over a year now that b43 (aka bcm43xx-mac80211) is going to
> replace bcm43xx. And we already do a parrallel release cycle with both drivers
> included so people can switch. What else do you want?

_First_, mark bcm43xx as unmaintained.  Then, it's not your problem any more.
Perhaps there's someone who'd be willing to maintain it.  Otherwise, it will be
dropped anyway after some time - when no one uses it any more.  Still, it need
not be (and IMHO it shouldn't be) your decision to drop it.

Greetings,
Rafael
