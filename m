Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3LCOUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:20:41 -0500
Message-ID: <1386080437.4393.26.camel@jlt4.sipsolutions.net> (sfid-20131203_152044_753217_9E739CA2)
Subject: Re: [PATCH 2/4] nl80211: back to default bitrate_mask correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 15:20:37 +0100
In-Reply-To: <1386060648-6020-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095101_211022_64F5435E)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386060648-6020-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131203_095101_211022_64F5435E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
> In case of empty NL80211_ATTR_TX_RATES attribute
> in nl80211_set_tx_bitrate_mask() function back to
> default bitrate mask.

Err what?

> +++ b/net/wireless/nl80211.c
> @@ -7311,9 +7311,6 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  	struct nlattr *tx_rates;
>  	struct ieee80211_supported_band *sband;
>  
> -	if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
> -		return -EINVAL;

Why?

johannes

