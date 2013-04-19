Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:38501 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030493Ab3DSOWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 10:22:13 -0400
Received: by mail-we0-f182.google.com with SMTP id m1so3639892wea.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 07:22:12 -0700 (PDT)
Date: Fri, 19 Apr 2013 16:16:45 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v3 2/3] mac80211/minstrel_ht: use the new rate control API
Message-ID: <20130419141645.GC8341@magnum.frso.rivierawaves.com> (sfid-20130419_162319_802351_CC461D19)
References: <1366376477-29376-1-git-send-email-nbd@openwrt.org>
 <1366376477-29376-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366376477-29376-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 19, 2013 at 03:01:16PM +0200, Felix Fietkau wrote:
> +	if (mp->hw->max_rates >= 2) {
> +		/*
> +		 * At least 2 tx rates supported, use max_prob_rate next */
>  
One \n too much.

> @@ -907,8 +919,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  	if (!n_supported)
>  		goto use_legacy;
>  
> -	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
> -	minstrel_ht_update_stats(mp, mi);
We need to keep it.

 
Karl
