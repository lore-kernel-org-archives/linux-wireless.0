Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2FFIkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:40:15 -0400
Message-ID: <1338972014.4513.16.camel@jlt3.sipsolutions.net> (sfid-20120606_104019_691106_66AFF329)
Subject: Re: [RFC 3/6] mac80211: add drv_* wrappers for channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:40:14 +0200
In-Reply-To: <1337342589-10617-4-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:

> +static inline void
> +drv_add_channel_context(struct ieee80211_local *local,
> +		        struct ieee80211_channel_context *ctx)
> +{
> +	if (local->ops->add_channel_context)
> +		local->ops->add_channel_context(&local->hw, ctx);
> +}

tracing would be good, but otherwise this is obviously good

johannes

