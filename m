Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50226 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756351AbaDHOA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 10:00:27 -0400
Message-ID: <1396965618.4418.17.camel@dubbel> (sfid-20140408_160031_712860_AEED9A15)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 17:00:18 +0300
In-Reply-To: <1396963807.11971.2.camel@jlt4.sipsolutions.net>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140331_134301_895786_6990540B) <1396963807.11971.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v3 00/13] cfg80211/mac80211: implement multi-vif chanctx
 reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-08 at 15:30 +0200, Johannes Berg wrote:
> On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:
> > Hi,
> > 
> > This is part of my multi-vif csa work. These
> > patches have been included in my recent big RFC.
> > I'm trying to split it up a bit.
> > 
> > The patchset incrementally improves chanctx
> > reservations in order to support multi-vif
> > reservations and in-place multi-vif reservations
> > (typically for single-channel hardware, but
> > multi-channel benefits from this too).
> > 
> > Some of the patches (the refcounting) were also
> > posted a while ago as a separate small RFC.
> > 
> > This is rebased on mac80211-next/master and my
> > CSA fixes/cleanups now.
> 
> I guess this looks fine ... Is Luca planning to pick it up first?

I can do that, whichever you prefer.

But Michal is going to resend with some comments by Eliad addressed,
right?

--
Luca.

