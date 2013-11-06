Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3KFMGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:06:07 -0500
Message-ID: <1383739560.14307.40.camel@jlt4.sipsolutions.net> (sfid-20131106_130611_073543_187C489D)
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Johannes Berg <johannes@sipsolutions.net>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>
Date: Wed, 06 Nov 2013 13:06:00 +0100
In-Reply-To: <1383738685.4256.50.camel@porter.coelho.fi>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
	 <1383735101.14307.25.camel@jlt4.sipsolutions.net>
	 <1383737255.4256.34.camel@porter.coelho.fi>
	 <1383737505.14307.37.camel@jlt4.sipsolutions.net>
	 <1383738685.4256.50.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 11:52 +0000, Coelho, Luciano wrote:

> Right.  I actually added this to the documentation, but I accidentally
> sent it as part of patch 1/2:
> 
> > +++ b/include/net/mac80211.h
> > @@ -2676,11 +2676,13 @@ enum ieee80211_roc_type {
> >   * @channel_switch_beacon: Starts a channel switch to a new channel.
> [...]
> > + *     If the CSA count starts as zero or 1, this function will not be called,
> > + *     since there won't be any time to beacon before the switch anyway.
> 
> This change should be in patch 2/2 (actually these two patches should
> probably be squashed, I just kept them separate so that reviewing my v2
> would be easier).
> 
> I can elaborate more in the documentation if you think it's necessary.

Ah, ok, I guess that's fine.

johannes

