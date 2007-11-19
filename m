Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbXKSWoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:44:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Tue, 20 Nov 2007 00:02:14 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
References: <20071119202121.6ad3fa70@morte> <20071119231935.535674ba@morte> <jehcjheubn.fsf@sykes.suse.de>
In-Reply-To: <jehcjheubn.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711200002.14993.rjw@sisk.pl> (sfid-20071119_224424_886420_B251EA56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, 19 of November 2007, Andreas Schwab wrote:
> Stefano Brivio <stefano.brivio@polimi.it> writes:
> 
> > On Mon, 19 Nov 2007 23:00:11 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> >> Well, are you 100% sure that everyone interested knows that this drivers
> >> is going out in 2.6.25 and no one will object?
> >
> > The maintainers know. Having both drivers in 2.6.24 should help find out if
> > there's anything which should be ironed out with b43/b43legacy, but right
> > now they are already working a lot better than bcm43xx, and they are more
> > stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> > 2.6.25.
> 
> b43 still does not work at all on ppc.

Well, in that case for ppc users the removal of bcm43xx will be a regression.

Greetings,
Rafael
