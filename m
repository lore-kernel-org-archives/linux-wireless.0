Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:58532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbXKWWEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 17:04:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: timeout problems with certain APs and b43
Date: Fri, 23 Nov 2007 23:21:56 +0100
Cc: bcm43xx-dev@lists.berlios.de, "John H." <mistamaila@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com> <200711232258.25965.rjw@sisk.pl> <1195855050.4149.179.camel@johannes.berg>
In-Reply-To: <1195855050.4149.179.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711232321.58516.rjw@sisk.pl> (sfid-20071123_220412_188556_9E741D7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 23 of November 2007, Johannes Berg wrote:
> 
> > > > on certain APs, the internet works for a long time then stops, and I
> > > > get authentication time outs, why?  It usually works again if I reset
> > > > the AP itself, which i should not have to do and don't have to if in
> > > > XP....
> > > 
> > > > wlan0: Initial auth_alg=0
> > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
> > > 
> > > Does it help to reload the b43 module? I think I have seen this problem
> > > before but always associated it with suspend/resume rather than a long
> > > time elapsing, I also thought it was due to bad power recalibration.
> > 
> > It seems that I can reproduce something similar on demand with an SMC wireless
> > router by moving my box sufficiently far away from it. :-)
> 
> Well, yeah, that's expected though, you lose signal at some point. Not
> expected is that it happens without moving anything. Unless the
> calibration code is wrong which wouldn't really surprise me either.

In my case, everything works just fine when the box is 6 meters away from the
AP (including a thick wall in between), but when I move it another 5-6 meters
away from the AP, things break down ...

I'd expect it to work at longer distances, but well. :-)

Greetings,
Rafael
