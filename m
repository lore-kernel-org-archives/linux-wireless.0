Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1ARKna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:43:30 -0500
Subject: Re: [PATCH 2/5] mac80211: initialize radar params + add driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <20110117161133.6EEA42080@mx.techwires.net>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.6EEA42080@mx.techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:44:14 +0100
Message-ID: <1295347454.3563.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 10:16 +0100, Bernhard Schmidt wrote:

> +static struct ieee80211_radar_parameters regdomain_params[] = {
> +	{ .cac_period = 60, .nol_period = 1800 },	/* FCC, correct? */
> +	{ .cac_period = 60, .nol_period = 1800 },	/* ETSI */
> +	{ .cac_period = 60, .nol_period = 1800 },	/* JP, correct? */
> +};

These parameters really need to come from cfg80211/userspace.

johannes

