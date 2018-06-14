Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965431AbeFNOYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 10:24:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/3] wcn36xx: Fix WEP104 encryption type
References: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org>
Date: Thu, 14 Jun 2018 17:24:19 +0300
In-Reply-To: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Mon, 28 May 2018 13:29:18 +0200")
Message-ID: <87k1r18mzw.fsf@kamboji.qca.qualcomm.com> (sfid-20180614_162439_756533_4E7B2E2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> writes:

> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index aeb5e6e..4648a78 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -512,7 +512,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
>  		break;
>  	case WLAN_CIPHER_SUITE_WEP104:
> -		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
> +		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP104;
>  		break;
>  	case WLAN_CIPHER_SUITE_CCMP:
>  		vif_priv->encrypt_type = WCN36XX_HAL_ED_CCMP;

No empty commit logs, please. I'll add "This is an obvious copy&paste
bug".

-- 
Kalle Valo
