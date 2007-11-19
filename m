Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:39222 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbXKSXOF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 18:14:05 -0500
Date: Tue, 20 Nov 2007 00:13:29 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Andreas Schwab <schwab@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
Subject: Re: [PATCH v3] remove bcm43xx
Message-ID: <20071120001329.3524494a@morte> (sfid-20071119_231410_436702_EF179473)
In-Reply-To: <jehcjheubn.fsf@sykes.suse.de>
References: <20071119202121.6ad3fa70@morte>
	<200711192300.12183.rjw@sisk.pl>
	<20071119231935.535674ba@morte>
	<jehcjheubn.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Nov 2007 23:36:44 +0100
Andreas Schwab <schwab@suse.de> wrote:

> Stefano Brivio <stefano.brivio@polimi.it> writes:
> 
> > On Mon, 19 Nov 2007 23:00:11 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> >> Well, are you 100% sure that everyone interested knows that this
> >> drivers is going out in 2.6.25 and no one will object?
> >
> > The maintainers know. Having both drivers in 2.6.24 should help find
> > out if there's anything which should be ironed out with b43/b43legacy,
> > but right now they are already working a lot better than bcm43xx, and
> > they are more stable. So I couldn't find a reason why we shouldn't
> > remove bcm43xx in 2.6.25.
> 
> b43 still does not work at all on ppc.

This is strange. Because it has been developed mainly on PPC. Plus, if you
could better define "does not work" as per
http://www.chiark.greenend.org.uk/~sgtatham/bugs.html, it would be great.


-- 
Ciao
Stefano
