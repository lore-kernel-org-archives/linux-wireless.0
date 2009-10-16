Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40569 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011AbZJPOQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 10:16:51 -0400
Date: Fri, 16 Oct 2009 10:05:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Willis <John.Willis@Distant-earth.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: add support for PG11 chips.
Message-ID: <20091016140504.GD4849@tuxdriver.com>
References: <01c201ca4d9c$c2c44500$484ccf00$@Willis@Distant-earth.com> <87vdifbyao.fsf@nokia.com> <87my3rn38e.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87my3rn38e.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 11:37:53AM +0300, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
> 
> > John Willis <John.Willis@Distant-earth.com> writes:
> >
> >> From: David-John Willis <John.Willis@Distant-earth.com>
> >>
> >> This simple patch adds support for the PG11 variant of the WL1251 chip as
> >> used on the OpenPandora OMAP3 device.
> >>
> >> Signed-off-by: David-John Willis <John.Willis@Distant-earth.com>
> 
> [...]
> 
> > This patch also enables PG10 support, but as that hardware revision is
> > untested I think it's better not to enable it. I'll edit the patch a bit
> > regarding this and then send it to John.
> 
> Oh, I noticed that Linville had already applied your patch. I'll send
> a patch on top of this to fix the issue.
> 
> Linville, is this ok for you?
> 
> Too many Johns here :)

Either way is fine -- it hasn't gone to Dave, so I can sort it out...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
