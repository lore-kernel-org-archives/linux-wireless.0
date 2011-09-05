Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1IEMGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:06:51 -0400
Subject: Re: [RFC v2 2/5] mac80211: adding 'scan_cancel' command.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315224151-16552-3-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-3-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 14:06:47 +0200
Message-ID: <1315224407.4075.8.camel@jlt3.sipsolutions.net> (sfid-20110905_140654_289363_2F20B4A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 15:02 +0300, Victor Goldenshtein wrote:

> +static void ieee80211_scan_cancel_req(struct wiphy *wiphy,
> +					struct net_device *dev)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	ieee80211_scan_cancel(sdata->local);

See my first mail -- scan_cancel() here isn't guaranteed to really do
anything at all.

johannes

