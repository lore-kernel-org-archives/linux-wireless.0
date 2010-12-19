Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0LSVgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 16:36:14 -0500
Subject: Re: Wireless channel stuck to -1 on mon0 (fix patch submission)
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: CalimeroTeknik <calimeroteknik@free.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTik5uML3gSD5aJE8CPwew8G5shp9BJgGUK608jTp@mail.gmail.com>
References: <4D0DE870.2050503@free.fr>
	 <AANLkTik5uML3gSD5aJE8CPwew8G5shp9BJgGUK608jTp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 22:36:12 +0100
Message-ID: <1292794572.8422.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-19 at 21:58 +0100, Gábor Stefanik wrote:
> This is a known problem, that has basically been WONTFIXed a while
> ago. I highly disagree with the reasoning, but the decision ultimately
> rests on Johannes. In the meantime, check patches.aircrack-ng.org for
> a workaround.
> 
> Johannes: I know that you consider reporting the actual channel of the
> PHY to be "confusing to users" when running with multiple virtual
> PHYs, but apparently this is what most users expect. Perhaps it
> *should* be implemented after all.

In which case it should be implemented properly, not half-baked like all
the patches we've seen so far.

johannes

