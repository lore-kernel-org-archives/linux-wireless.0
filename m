Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44474 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2993844AbdDZIJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:09:01 -0400
Message-ID: <1493194138.2464.10.camel@sipsolutions.net> (sfid-20170426_101255_482027_024F9905)
Subject: Re: [PATCH 0/9] cfg80211/mac80211 patches from our internal tree
 2017-04-26
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:08:58 +0200
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Avraham Stern (3):
>   mac80211: Add support for BSS max idle period element
>   cfg80211: unify cfg80211_roamed() and cfg80211_roamed_bss()
>   cfg80211/nl80211: add authorized flag to roaming event

I'm going to let these get a bit more time on the list.

Arend, it'd be nice if you could take a look as well.

> Emmanuel Grumbach (1):
>   mac80211: don't parse encrypted management frames in
>     ieee80211_frame_acked
> 
> Johannes Berg (2):
>   ieee80211: fix kernel-doc parsing errors
>   mac80211: disentangle iflist_mtx and chanctx_mtx
> 
> Luca Coelho (3):
>   ieee80211: add SUITE_B AKM selectors
>   ieee80211: add FT-802.1X AKM suite selector
>   mac80211: make multicast variable a bool in
> ieee80211_accept_frame()

But these seem uncontroversial, so applied.

johannes
