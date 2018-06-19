Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:45406 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbeFSWq1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 18:46:27 -0400
Received: by mail-lf0-f67.google.com with SMTP id a13-v6so1917268lfk.12
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 15:46:26 -0700 (PDT)
Date: Wed, 20 Jun 2018 00:46:23 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 4/6] ath10k: Add debug mask for QMI layer
Message-ID: <20180619224623.GC1635@centauri.lan> (sfid-20180620_004638_296063_2E98C850)
References: <20180605123651.1589-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123651.1589-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Niklas Cassel <niklas.cassel@linaro.org>

On Tue, Jun 05, 2018 at 06:06:51PM +0530, Govind Singh wrote:
> Add debug mask to control debug info of ath10k qmi
> messaging layer.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/debug.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index 0afca5c106b6..a2f84fdb9131 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -44,6 +44,7 @@ enum ath10k_debug_mask {
>  	ATH10K_DBG_USB		= 0x00040000,
>  	ATH10K_DBG_USB_BULK	= 0x00080000,
>  	ATH10K_DBG_SNOC		= 0x00100000,
> +	ATH10K_DBG_QMI		= 0x00200000,
>  	ATH10K_DBG_ANY		= 0xffffffff,
>  };
>  
> -- 
> 2.17.0
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
