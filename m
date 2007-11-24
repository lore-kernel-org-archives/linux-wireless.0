Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXKXK7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 05:59:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: timeout problems with certain APs and b43
Date: Sat, 24 Nov 2007 12:17:37 +0100
Cc: bcm43xx-dev@lists.berlios.de, "John H." <mistamaila@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com> <200711232321.58516.rjw@sisk.pl> <1195893331.4149.190.camel@johannes.berg>
In-Reply-To: <1195893331.4149.190.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711241217.38559.rjw@sisk.pl> (sfid-20071124_105946_352438_DCC44EA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 24 of November 2007, Johannes Berg wrote:
> 
> > > > It seems that I can reproduce something similar on demand with an SMC wireless
> > > > router by moving my box sufficiently far away from it. :-)
> > > 
> > > Well, yeah, that's expected though, you lose signal at some point. Not
> > > expected is that it happens without moving anything. Unless the
> > > calibration code is wrong which wouldn't really surprise me either.
> > 
> > In my case, everything works just fine when the box is 6 meters away from the
> > AP (including a thick wall in between), but when I move it another 5-6 meters
> > away from the AP, things break down ...
> > 
> > I'd expect it to work at longer distances, but well. :-)
> 
> Yeah, but keep in mind we reverse engineered all the calibration code.

Sure. :-)

For me it's not a problem (everywhere I use the wireless, there are APs close
enough ;-)), but it seems related to what's been reported in this thread.

Greetings,
Rafael
