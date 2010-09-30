Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0I3RgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 13:36:25 -0400
Subject: Re: [ath9k-devel] Modulation schemes on ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Mike Pithouse <mike.pithouse@vegastream.com>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com>
References: <9D3ED2EB2589B641B6CCA9F529CAA6A2F258CB@exbe12.nasstar-t1.net>
	 <AANLkTi=aBPTYZB62Jup4=10_D2wxEgVaBormJcZb6qyT@mail.gmail.com>
	 <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net>
	 <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 19:36:55 +0200
Message-ID: <1285868215.5137.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 10:33 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 30, 2010 at 10:26 AM, Mike Pithouse
> <mike.pithouse@vegastream.com> wrote:
> > Just the ticket - thank you.
> >
> > I see there's currently some 'inactive' code that will allow the same command to be used to set the MCS index.
> >
> > Do you know when/if this code will be available?  Alternatively, is there another method currently available to set MCS index?
> 
> Johannes, is this a TODO still?

You can only do legacy right now, we don't have the
nl80211/cfg80211/mac80211 infrastructure in place for it at this point.

johannes

