Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:58471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbXKWVlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 16:41:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: timeout problems with certain APs and b43
Date: Fri, 23 Nov 2007 22:58:24 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John H." <mistamaila@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com> <1195812310.4149.73.camel@johannes.berg>
In-Reply-To: <1195812310.4149.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711232258.25965.rjw@sisk.pl> (sfid-20071123_214119_262269_EBE2D091)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 23 of November 2007, Johannes Berg wrote:
> 
> > on certain APs, the internet works for a long time then stops, and I
> > get authentication time outs, why?  It usually works again if I reset
> > the AP itself, which i should not have to do and don't have to if in
> > XP....
> 
> > wlan0: Initial auth_alg=0
> > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
> 
> Does it help to reload the b43 module? I think I have seen this problem
> before but always associated it with suspend/resume rather than a long
> time elapsing, I also thought it was due to bad power recalibration.

It seems that I can reproduce something similar on demand with an SMC wireless
router by moving my box sufficiently far away from it. :-)

Greetings,
Rafael
