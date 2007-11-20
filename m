Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47811
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXKTOLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 09:11:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Tue, 20 Nov 2007 15:09:55 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20071119202121.6ad3fa70@morte> <20071119231935.535674ba@morte> <200711192357.44407.rjw@sisk.pl>
In-Reply-To: <200711192357.44407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711201509.55763.mb@bu3sch.de> (sfid-20071120_141111_004336_C0D0A050)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 November 2007 23:57:43 Rafael J. Wysocki wrote:
> > Having both drivers in 2.6.24 should help find out if 
> > there's anything which should be ironed out with b43/b43legacy, but right
> > now they are already working a lot better than bcm43xx, and they are more
> > stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> > 2.6.25.
> 
> Many people use the old driver and you are forcing them to switch in a rather
> unfriendly fashion.
> 
> Moreover, the switch generally involves a configuration change (on my system
> eth1 became wlan0) and is not _that_ seamless.
> 
> IMvHO, the schedule of the removal of this driver should be discussed on LKML.

Ok, so we are going to add Rafael J. Wysocki as the bcm43xx maintainer
and remove everyone else. I'm OK with that.

It is known for over a year now that b43 (aka bcm43xx-mac80211) is going to
replace bcm43xx. And we already do a parrallel release cycle with both drivers
included so people can switch. What else do you want?

-- 
Greetings Michael.
