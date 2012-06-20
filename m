Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2FTIkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:40:40 -0400
Message-ID: <1340181637.4655.35.camel@jlt3.sipsolutions.net> (sfid-20120620_104043_069162_9F8CBAF4)
Subject: Re: [PATCH v2 2/7] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 10:40:37 +0200
In-Reply-To: <1340111463-4554-2-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-2-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:10 +0300, Victor Goldenshtein wrote:

> +void ieee80211_radar_detected(struct ieee80211_vif *vif, u16 freq, gfp_t gfp)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);

add tracing please, also maybe pass channel instead of freq

johannes

