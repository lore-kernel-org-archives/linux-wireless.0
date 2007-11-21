Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48198
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXKUNq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 08:46:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Wed, 21 Nov 2007 14:45:29 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20071119202121.6ad3fa70@morte> <200711201509.55763.mb@bu3sch.de> <200711210026.49732.rjw@sisk.pl>
In-Reply-To: <200711210026.49732.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711211445.30142.mb@bu3sch.de> (sfid-20071121_134704_715281_F7D763D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 November 2007 00:26:48 Rafael J. Wysocki wrote:
> On Tuesday, 20 of November 2007, Michael Buesch wrote:
> > On Monday 19 November 2007 23:57:43 Rafael J. Wysocki wrote:
> > > > Having both drivers in 2.6.24 should help find out if 
> > > > there's anything which should be ironed out with b43/b43legacy, but right
> > > > now they are already working a lot better than bcm43xx, and they are more
> > > > stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> > > > 2.6.25.
> > > 
> > > Many people use the old driver and you are forcing them to switch in a rather
> > > unfriendly fashion.
> > > 
> > > Moreover, the switch generally involves a configuration change (on my system
> > > eth1 became wlan0) and is not _that_ seamless.
> > > 
> > > IMvHO, the schedule of the removal of this driver should be discussed on LKML.
> > 
> > Ok, so we are going to add Rafael J. Wysocki as the bcm43xx maintainer
> > and remove everyone else. I'm OK with that.
> 
> [That wasn't nice.]

Exactly.

> _First_, mark bcm43xx as unmaintained.  Then, it's not your problem any more.
> Perhaps there's someone who'd be willing to maintain it.  Otherwise, it will be
> dropped anyway after some time - when no one uses it any more.  Still, it need
> not be (and IMHO it shouldn't be) your decision to drop it.

Who is responsible to do that decision, if the driver authors that wrote all the
code aren't?
I'd be very happy to shift bcm43xx maintainership to someone else, but
there is _nobody_ who wants to do it. Face it. Nobody wants bcm43xx anymore.
And the only sane way to handle this is to run one release cycle with both
drivers included and remove the old driver after that.

bcm43xx is basically dropped since a year and everybody who cares knows that.
And nobody cares to maintain that piece of junk in the future.

-- 
Greetings Michael.
