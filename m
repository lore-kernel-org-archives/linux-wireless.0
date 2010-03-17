Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0CQQVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:21:19 -0400
Subject: Re: [RFC PATCHv3 2/2] mac80211: Add support for connection quality
 monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268830877-5162-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830877-5162-3-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:21:19 -0700
Message-ID: <1268842879.5989.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry about the multiple mails ... This'll be the last.

> @@ -1506,4 +1531,5 @@ struct cfg80211_ops mac80211_config_ops = {
>  	.remain_on_channel = ieee80211_remain_on_channel,
>  	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
>  	.action = ieee80211_action,
> +	.set_cqm_config = ieee80211_set_cqm_config

Please add a trailing comma so future changes here don't need to edit
your line.

johannes

