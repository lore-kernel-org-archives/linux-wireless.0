Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2478 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbXKUOAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 09:00:25 -0500
Date: Wed, 21 Nov 2007 08:59:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: schedule bcm43xx removal for 2.6.26 -- Re: [PATCH v3] remove
	bcm43xx
Message-ID: <20071121135927.GC8792@tuxdriver.com> (sfid-20071121_140031_161880_FF92F482)
References: <20071119202121.6ad3fa70@morte> <200711192357.44407.rjw@sisk.pl> <200711201509.55763.mb@bu3sch.de> <200711210026.49732.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711210026.49732.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2007 at 12:26:48AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 20 of November 2007, Michael Buesch wrote:

> > It is known for over a year now that b43 (aka bcm43xx-mac80211) is going to
> > replace bcm43xx. And we already do a parrallel release cycle with both drivers
> > included so people can switch. What else do you want?
> 
> _First_, mark bcm43xx as unmaintained.  Then, it's not your problem any more.
> Perhaps there's someone who'd be willing to maintain it.  Otherwise, it will be
> dropped anyway after some time - when no one uses it any more.  Still, it need
> not be (and IMHO it shouldn't be) your decision to drop it.

It is probably true that we haven't communicated this very well
outside the wireless team.  We probably should have added bcm43xx to
the feature removal schedule before the 2.6.24 merge window closed.

How about if we mark bcm43xx as "Obsolete" in MAINTAINERS and add
an entry to Documentation/feature-removal-schedule.txt with a "When"
of 2.6.26?  I think that should give everyone sufficient notice...?

John
-- 
John W. Linville
linville@tuxdriver.com
