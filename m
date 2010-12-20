Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49191 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0LTOPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 09:15:07 -0500
Date: Mon, 20 Dec 2010 09:11:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	CalimeroTeknik <calimeroteknik@free.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: Wireless channel stuck to -1 on mon0 (fix patch submission)
Message-ID: <20101220141134.GA10104@tuxdriver.com>
References: <4D0DE870.2050503@free.fr>
 <AANLkTik5uML3gSD5aJE8CPwew8G5shp9BJgGUK608jTp@mail.gmail.com>
 <1292794572.8422.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1292794572.8422.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 19, 2010 at 10:36:12PM +0100, Johannes Berg wrote:
> On Sun, 2010-12-19 at 21:58 +0100, Gábor Stefanik wrote:
> > This is a known problem, that has basically been WONTFIXed a while
> > ago. I highly disagree with the reasoning, but the decision ultimately
> > rests on Johannes. In the meantime, check patches.aircrack-ng.org for
> > a workaround.
> > 
> > Johannes: I know that you consider reporting the actual channel of the
> > PHY to be "confusing to users" when running with multiple virtual
> > PHYs, but apparently this is what most users expect. Perhaps it
> > *should* be implemented after all.
> 
> In which case it should be implemented properly, not half-baked like all
> the patches we've seen so far.

This does continue to pop-up.  Do you have a link to a description
of a proper implementation?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
