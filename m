Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:32926
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXKUSWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 13:22:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: schedule bcm43xx removal for 2.6.26 -- Re: [PATCH v3] remove bcm43xx
Date: Wed, 21 Nov 2007 19:20:48 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20071119202121.6ad3fa70@morte> <200711210026.49732.rjw@sisk.pl> <20071121135927.GC8792@tuxdriver.com>
In-Reply-To: <20071121135927.GC8792@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200711211920.48640.mb@bu3sch.de> (sfid-20071121_182218_660786_49BCF8B1)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 November 2007 14:59:27 John W. Linville wrote:
> On Wed, Nov 21, 2007 at 12:26:48AM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 20 of November 2007, Michael Buesch wrote:
> 
> > > It is known for over a year now that b43 (aka bcm43xx-mac80211) is going to
> > > replace bcm43xx. And we already do a parrallel release cycle with both drivers
> > > included so people can switch. What else do you want?
> > 
> > _First_, mark bcm43xx as unmaintained.  Then, it's not your problem any more.
> > Perhaps there's someone who'd be willing to maintain it.  Otherwise, it will be
> > dropped anyway after some time - when no one uses it any more.  Still, it need
> > not be (and IMHO it shouldn't be) your decision to drop it.
> 
> It is probably true that we haven't communicated this very well
> outside the wireless team.  We probably should have added bcm43xx to
> the feature removal schedule before the 2.6.24 merge window closed.
> 
> How about if we mark bcm43xx as "Obsolete" in MAINTAINERS and add
> an entry to Documentation/feature-removal-schedule.txt with a "When"
> of 2.6.26?  I think that should give everyone sufficient notice...?

So, is SoftMAC already scheduled?
Otherwise, I think when we are about to remove bcm43xx in 2.6.25 someone
is going to complain that removal of softmac was not scheduled...

Btw: Does someone actually read that feature-removal-schedule.txt file?

-- 
Greetings Michael.
