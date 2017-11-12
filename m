Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdKLMvr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Nov 2017 07:51:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, Eyal Ilsar <eilsar@codeaurora.org>
Subject: Re: [PATCH] wcn36xx: Set BTLE coexistence related configuration values to defaults
References: <1510490904-21255-1-git-send-email-rfried@codeaurora.org>
Date: Sun, 12 Nov 2017 14:51:40 +0200
In-Reply-To: <1510490904-21255-1-git-send-email-rfried@codeaurora.org> (Ramon
        Fried's message of "Sun, 12 Nov 2017 14:48:24 +0200")
Message-ID: <87fu9jwtgj.fsf@kamboji.qca.qualcomm.com> (sfid-20171112_135202_837204_69C18C32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> writes:

> From: Eyal Ilsar <eilsar@codeaurora.org>
>
> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>  drivers/net/wireless/ath/wcn36xx/smd.c  | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index b83f01d..0d4ed41 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -27,7 +27,7 @@
>  #include <linux/soc/qcom/wcnss_ctrl.h>
>  #include "wcn36xx.h"
>  
> -unsigned int wcn36xx_dbg_mask;
> +unsigned int wcn36xx_dbg_mask = WCN36XX_DBG_NONE;

And this looks unrelated to the title?

-- 
Kalle Valo
