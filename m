Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3CTVBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:01:35 -0400
Message-ID: <1363813292.9284.5.camel@jlt4.sipsolutions.net> (sfid-20130320_220138_772062_2676BF4E)
Subject: Re: [PATCH 1/4] cfg80211: add P2P Notice of Absence attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 Mar 2013 22:01:32 +0100
In-Reply-To: <CAFED-jmrmbMb=puPn1Nu6zc2SnZvJNWFnwV4CHNNjo7E_yKr1g@mail.gmail.com> (sfid-20130320_201348_085802_2C484E51)
References: <CAFED-jmrmbMb=puPn1Nu6zc2SnZvJNWFnwV4CHNNjo7E_yKr1g@mail.gmail.com>
	 (sfid-20130320_201348_085802_2C484E51)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since you're going to have to resend anyway ...

> +/* Notice of Absence attribute - described in P2P spec 4.1.14 */
> +/* Typical max value used here */
> +#define IEEE80211_P2P_NOA_DESC_MAX	4
> +
> +struct ieee80211_p2p_noa_desc {
> +	u8	count;
> +	__le32	duration;
> +	__le32	interval;
> +	__le32	start_time;
> +} __packed;
> +
> +struct ieee80211_p2p_noa_attr {
> +	u8	index;
> +	u8	oppps_ctwindow;
> +	struct ieee80211_p2p_noa_desc desc[IEEE80211_P2P_NOA_DESC_MAX];

I think you should just have a single space, even if that doesn't line
up any more then.

johannes

