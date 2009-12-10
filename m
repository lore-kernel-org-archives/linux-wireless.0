Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40173 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZLJOAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 09:00:11 -0500
Date: Thu, 10 Dec 2009 08:47:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: Revised wireless tree management practices
Message-ID: <20091210134733.GC11112@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ljhb0x0h.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 03:38:38PM +0200, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
> 
> > Greetings,
> 
> Hi,
> 
> > So I'm tired of a) being asked how wireless-testing is managed; and,
> > b) having trouble explaining it.  I think it is time to move to a
> > more conventional process for wireless patches.
> 
> Hopefully this also reduces your workload. There is quite a lot of
> wireless patches floating around nowadays.
> 
> > More likely, it means I may have to push an occasional revert
> > through those trees that I might have otherwise avoided.
> 
> Having reverts in the tree doesn't sound that bad. Even we do mistakes
> sometimes, no need to hide them :)
> 
> > For now, the main change to wireless-testing will be that I will be
> > pulling from wireless-2.6 and wireless-next-2.6 rather than reapplying
> > most patches.  This should limit (and possibly eliminate) the confusing
> > patch-revert-reapply-repeat practice I have been using there for a
> > long time.  However, I still anticipate using w-t as a holding area
> > for questionable patches.  So, at least some patches may still get
> > the revert-reapply treatment.  I may ask Stephen to pull w-t into
> > linux-next in order to expand testing of any such patches.
> 
> I have two questions:
> 
> What tree should I base my patches on?
> 
> What about testing? Which tree is best to use for testing latest and
> greatest wireless patches?

I still see value in a tree that has a reasonably stable base and
contains both wireless fixes and wireless features.  So, I think
wireless-testing remains as the focal point for wireless LAN testing
and development.  I'll just be getting patches there in a slightly
different process.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
