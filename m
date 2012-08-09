Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2HILvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 07:51:39 -0400
Date: Thu, 9 Aug 2012 13:51:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20120809115109.GB3516@redhat.com> (sfid-20120809_135144_010311_92AE7650)
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
 <1344426823-1795-2-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344426823-1795-2-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2012 at 02:53:37PM +0300, Victor Goldenshtein wrote:
> +	cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> +	if (cac_type != NL80211_CHAN_HT20)
> +		return -EOPNOTSUPP;
Since only HT20 is supported, what for we have this variable?

Stanislaw
