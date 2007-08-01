Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427AbXHALht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:37:49 -0400
Subject: Re: libertas: blows chunks on failed firmware load
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Andy Green <andy@warmcat.com>
In-Reply-To: <200708011315.10439.hs4233@mail.mn-solutions.de>
References: <46AF913F.9010006@warmcat.com> <46B01F86.5050406@warmcat.com>
	 <1185966204.29690.2.camel@xo-13-A4-25.localdomain>
	 <200708011315.10439.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 07:35:16 -0400
Message-Id: <1185968116.29690.14.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-01 at 13:15 +0200, Holger Schurig wrote:
> > Yeah, I'm wondering whether we should change that...  I don't
> > know what the policy on changing driver names is though, but
> > given that the driver isn't extensively used yet, we may be
> > able to.
> 
> I'd say
> 
> libertas_cs     for card-services cards (CF Cards, PCMCIA etc)
> libertas_usb    for USB cards
> libertas_sdio   for SDIO based cards
> 
> That makes the names orthogonal :-)

Right, but that doesn't solve the original issue that the driver is
named "usb8xxx" and doesn't work with the 833x series.  Maybe we just
ignore that.  The current driver will likely work with the libertas 86xx
chips (8682, 8686, 8688) too, so that just leaves the 833x, 831x, and
830x chips.  Some of those are really, really old.  Others (like 833x)
you can still find in a lot of places.

Dan


