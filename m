Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AaTtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 14:49:20 -0500
Subject: Re: [PATCH] iwlwifi: make "Tx aggregation enabled on ra =" be at
 DEBUG level
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328038849-12620-1-git-send-email-linville@tuxdriver.com>
References: <1328038849-12620-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 11:41:50 -0800
Message-ID: <1328038910.3024.3.camel@wwguy-ubuntu> (sfid-20120131_204924_041864_B9AC5EF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 14:40 -0500, John W. Linville wrote:
> Average users either don't care or they think that message indicates a
> problem...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> index a8c6880..20d418c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> @@ -620,7 +620,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
>  	sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
>  		sta_priv->max_agg_bufsize;
>  
> -	IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
> +	IWL_DEBUG(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
maybe use IWL_DEBUG_HT

Wey


