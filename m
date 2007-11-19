Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXKSWkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:40:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Mon, 19 Nov 2007 23:57:43 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl> <20071119231935.535674ba@morte>
In-Reply-To: <20071119231935.535674ba@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711192357.44407.rjw@sisk.pl> (sfid-20071119_224049_686469_3D7B65CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, 19 of November 2007, Stefano Brivio wrote:
> On Mon, 19 Nov 2007 23:00:11 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Well, are you 100% sure that everyone interested knows that this drivers
> > is going out in 2.6.25 and no one will object?
> 
> The maintainers know.

I mean the users.

> Having both drivers in 2.6.24 should help find out if 
> there's anything which should be ironed out with b43/b43legacy, but right
> now they are already working a lot better than bcm43xx, and they are more
> stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> 2.6.25.

Many people use the old driver and you are forcing them to switch in a rather
unfriendly fashion.

Moreover, the switch generally involves a configuration change (on my system
eth1 became wlan0) and is not _that_ seamless.

IMvHO, the schedule of the removal of this driver should be discussed on LKML.

Greetings,
Rafael
