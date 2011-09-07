Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1IGMYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:35 -0400
Subject: Re: [PATCH] nl80211/cfg80211/mac80211: fix wme docs
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315296872-20424-1-git-send-email-eliad@wizery.com> (sfid-20110906_101306_767250_6A5D3668)
References: <1315296872-20424-1-git-send-email-eliad@wizery.com>
	 (sfid-20110906_101306_767250_6A5D3668)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 11:43:56 +0200
Message-ID: <1315388636.4002.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   * enum nl80211_sta_wme_attr - station WME attributes
>   * @__NL80211_STA_WME_INVALID: invalid number for nested attribute
> - * @NL80211_STA_WME_QUEUES: bitmap of uapsd queues.
> + * @NL80211_STA_WME_UAPSD_QUEUES: bitmap of uapsd queues.
>   * @NL80211_STA_WME_MAX_SP: max service period.

Can you also note what the format of these is, i.e. that the MAX_SP is
like in the QoS info field but shifted down, and the queues is the AC
bitmap like in the QoS info field?

I'll send the validation patch separately.

Thx,
Johannes

