Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23407 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbeIDK0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 06:26:35 -0400
Message-ID: <399483f28108ba4154d824ec0e55bbd890ca1bf9.camel@intel.com> (sfid-20180904_080357_093721_527BF408)
Subject: Re: [PATCH] iwlwifi: mvm:  fix spelling mistake "Recieved" ->
 "Received"
From: Luciano Coelho <luciano.coelho@intel.com>
To: Colin King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2018 09:02:56 +0300
In-Reply-To: <20180826223117.12892-1-colin.king@canonical.com>
References: <20180826223117.12892-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-08-26 at 23:31 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in debug message.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> index b15b0d84bb7e..5f32d3131d62 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> @@ -3320,7 +3320,7 @@ static bool iwl_mvm_rx_aux_roc(struct iwl_notif_wait_data *notif_wait,
>  	resp = (void *)pkt->data;
>  
>  	IWL_DEBUG_TE(mvm,
> -		     "Aux ROC: Recieved response from ucode: status=%d uid=%d\n",
> +		     "Aux ROC: Received response from ucode: status=%d uid=%d\n",
>  		     resp->status, resp->event_unique_id);
>  
>  	te_data->uid = le32_to_cpu(resp->event_unique_id);

Thanks! I pushed this to our internal tree and it will reach upstream
following our normal process.

--
Cheers,
Luca.
