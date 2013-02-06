Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3BFRfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:35:52 -0500
Message-ID: <1360172173.7910.54.camel@jlt4.sipsolutions.net> (sfid-20130206_183555_599537_5B8CB494)
Subject: Re: [PATCHv8 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 06 Feb 2013 18:36:13 +0100
In-Reply-To: <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:

> +++ b/net/mac80211/cfg.c

> @@ -1796,6 +1797,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
>  	/* can mesh use other SMPS modes? */
>  	sdata->smps_mode = IEEE80211_SMPS_OFF;
>  	sdata->needed_rx_chains = sdata->local->rx_chains;
> +	sdata->radar_required = true;

err?

johannes

