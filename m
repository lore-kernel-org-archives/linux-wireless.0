Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab2EaMsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:48:03 -0400
Message-ID: <1338468480.9102.5.camel@jlt3.sipsolutions.net> (sfid-20120531_144817_872337_4BEBC5F1)
Subject: Re: [PATCH v3] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 31 May 2012 14:48:00 +0200
In-Reply-To: <1338467755-8331-1-git-send-email-victorg@ti.com>
References: <1338467755-8331-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 15:35 +0300, Victor Goldenshtein wrote:

> +DEFINE_EVENT(local_sdata_evt, drv_get_rssi,
> +	TP_PROTO(struct ieee80211_local *local,
> +		 struct ieee80211_sub_if_data *sdata),
> +	TP_ARGS(local, sdata)
> +);

Shouldn't that also trace the station?

johannes

