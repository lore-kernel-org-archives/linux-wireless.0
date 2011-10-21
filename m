Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1JUKD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 06:03:57 -0400
Subject: Re: [RFC 3/7] mac80211: mesh non-peer power mode indication in
 beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAG5dHkQTpfXvhC8w_1z5MvuKxWV32u2+PM8VKq4Lc5pZm2hAug@mail.gmail.com> (sfid-20111021_103725_207935_F2BAF542)
References: <CAG5dHkQTpfXvhC8w_1z5MvuKxWV32u2+PM8VKq4Lc5pZm2hAug@mail.gmail.com>
	 (sfid-20111021_103725_207935_F2BAF542)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 12:03:53 +0200
Message-ID: <1319191433.3964.10.camel@jlt3.sipsolutions.net> (sfid-20111021_120413_690828_80FC6149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-21 at 12:37 +0400, Ivan Bezyazychnyy wrote:

> +	if (sdata->u.mesh.mshcfg.power_mode == NL80211_MESH_POWER_DEEP_SLEEP) {
> +		*pos |= MESHCONF_CAPAB_PS_LEVEL;
> +	}

braces?

johannes

