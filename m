Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23118 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZGaS5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:57:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:57:16 -0700
Date: Fri, 31 Jul 2009 11:57:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] at76c50x-usb: remove unneeded flush_workqueue() at
 usb disconnect
Message-ID: <20090731185707.GC7895@mosca>
References: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com>
 <87ws5pnze4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87ws5pnze4.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 11:24:19PM -0700, Kalle Valo wrote:
> "Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:
> 
> > This driver only uses the mac80211 workqueue and mac80211 requires us to
> > cancel all work at driver stop. Since we now have the cancels in the right
> > places at stop() we really don't need to flush the mac80211 workqueue so
> > remove it.
> >
> > Cc: Kalle Valo <kalle.valo@iki.fi>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Acked-by: Kalle Valo <kalle.valo@iki.fi>
> 
> But I only saw patch 1/2, was there also 2/2?

Yeah patch 2/2 was the mac80211 changes.

  Luis
