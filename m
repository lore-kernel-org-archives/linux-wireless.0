Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36058 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbeF2Jqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:46:32 -0400
Message-ID: <1530265590.3481.53.camel@sipsolutions.net> (sfid-20180629_114638_878639_E55125B7)
Subject: Re: [PATCH 3/4] cfg80211: Add support to notify station's txrate
 crossing event
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:46:30 +0200
In-Reply-To: <1528887539-26821-4-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
         <1528887539-26821-4-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd say squash this with patch 1 - there's no point in adding the
configurations if you can't use them :-)

> +void
> +cfg80211_sta_mon_txrate_notify(struct net_device *dev, const u8 *peer,
> +		enum nl80211_sta_mon_txrate_threshold_event txrate_event,
> +		u32 txrate_level, gfp_t gfp)

Maybe the actual MCS would be useful?

johannes
