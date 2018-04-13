Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbeDMHtm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 03:49:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 13 Apr 2018 13:19:41 +0530
From: Maharaja Kennadyrajan <mkenna@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix a typo in ath10k_wmi_set_wmm_param()
In-Reply-To: <1523605711-1874-1-git-send-email-mkenna@codeaurora.org>
References: <1523605711-1874-1-git-send-email-mkenna@codeaurora.org>
Message-ID: <6d423aeaf1011dc25e5caa57d11d2d1b@codeaurora.org> (sfid-20180413_094945_243809_91BD34C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Sorry for the inconvenience. Please ignore this duplicate patch.
Please use the previous patch.


On 2018-04-13 1:18 pm, mkenna@codeaurora.org wrote:
> From: Maharaja Kennadyrajan <mkenna@codeaurora.org>
> 
> Fix a typo in the function ath10k_wmi_set_wmm_param().
> 
> Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
> b/drivers/net/wireless/ath/ath10k/wmi.c
> index c5e1ca5..727c965 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -7648,7 +7648,7 @@ void ath10k_wmi_set_wmm_param(struct
> wmi_wmm_params *params,
>  	cmd->param = __cpu_to_le32(param);
> 
>  	ath10k_dbg(ar, ATH10K_DBG_WMI,
> -		   "wmi pdev get tcp config param:%d\n", param);
> +		   "wmi pdev get tpc config param %d\n", param);
>  	return skb;
>  }

-- 
Regards,
Maha
