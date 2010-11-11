Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:42840 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0KKTIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:08:37 -0500
Message-ID: <20101111210824.685154i2r52oacqo@hayate.sektori.org>
Date: Thu, 11 Nov 2010 21:08:24 +0200
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "John Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211/mac80211: allow per-station GTKs
References: <1286300370.3641.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286300370.3641.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Johannes Berg" <johannes@sipsolutions.net>:

> @@ -1312,6 +1314,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_4ADDR_AP			= BIT(5),
>  	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
>  	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
> +	WIPHY_FLAG_IBSS_RSN			= BIT(7),
>  };

This should be BIT(8), right?

-Jussi

