Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2ILSvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 14:51:55 -0400
Message-ID: <1347475950.4293.14.camel@jlt4.sipsolutions.net> (sfid-20120912_205158_989233_79567A8F)
Subject: Re: [RFC v2 02/12] mac80211: introduce new ieee80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 12 Sep 2012 20:52:30 +0200
In-Reply-To: <1347369983-12459-3-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152604_265478_E6F20D03)
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
	 <1347369983-12459-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120911_152604_265478_E6F20D03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-11 at 15:26 +0200, Johannes Berg wrote:

> +	void (*add_chanctx)(struct ieee80211_hw *hw,
> +			    struct ieee80211_chanctx_conf *ctx);

So one patch I had updated this so it can fail, I should probably roll
that into the right patches though.

> +	void (*assign_vif_chanctx)(struct ieee80211_hw *hw,
> +				   struct ieee80211_vif *vif,
> +				   struct ieee80211_chanctx_conf *ctx);

I also noticed that this should be allowed to fail as well, so I'll
change that too.

johannes

