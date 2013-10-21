Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20172 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JUGbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 02:31:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: extend number of AP interfaces for 10.X firmware
References: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
	<1382090878-22216-2-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 21 Oct 2013 09:31:08 +0300
In-Reply-To: <1382090878-22216-2-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 18 Oct 2013 12:07:58 +0200")
Message-ID: <87iowruocz.fsf@kamboji.qca.qualcomm.com> (sfid-20131021_083120_082633_4A95A45B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This firmware can support up to 8 AP interfaces.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index af046c4..dc65dcd 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3255,7 +3255,7 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
>  	.types	= BIT(NL80211_IFTYPE_STATION)
>  	},
>  	{
> -	.max	= 7,
> +	.max	= 8,
>  	.types	= BIT(NL80211_IFTYPE_AP)
>  	},
>  };

Why only with 10.x firmware branch? Doesn't the main branch support 8
interfaces?

-- 
Kalle Valo
