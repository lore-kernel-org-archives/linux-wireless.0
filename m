Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2FTIPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:15:53 -0400
Message-ID: <1340180149.4655.23.camel@jlt3.sipsolutions.net> (sfid-20120620_101606_136330_F25F4269)
Subject: Re: [PATCH v4] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:15:49 +0200
In-Reply-To: <1340173975-13609-1-git-send-email-victorg@ti.com>
References: <1340173975-13609-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 09:32 +0300, Victor Goldenshtein wrote:

> +	trace_drv_get_rssi(local, sdata);
> +	ret = local->ops->get_rssi(&local->hw, &sdata->vif, sta, rssi_dbm);
> +	trace_drv_return_int(local, ret);

Where are you tracing the sta?

And why not trace the value returned in *rssi_dbm?

johannes

