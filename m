Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:18956 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYFOVhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 17:37:55 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4095990waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 14:37:55 -0700 (PDT)
Message-ID: <1ba2fa240806151437t2d14f47fg8190bc51fdd680ab@mail.gmail.com> (sfid-20080615_233759_635878_89363FCE)
Date: Mon, 16 Jun 2008 00:37:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH] iwl4965: remove useless code
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <f6ca9fed0806151338l5d6968a9w5c3823577551ef93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806151338l5d6968a9w5c3823577551ef93@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 15, 2008 at 11:38 PM, drago01 <drago01@gmail.com> wrote:
> Hi,
> while reading throught the iwlwifi code I spotted this code which does nothing.
>
> The attached patch removes it, when the function is turned into an non
> nop it can be re added.
>
> -----------
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index f591168..2184a0b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -3547,9 +3547,6 @@ static int iwl4965_mac_get_tx_stats(struct
> ieee80211_hw *hw,
>  static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
>                             struct ieee80211_low_level_stats *stats)
>  {
> -       struct iwl_priv *priv = hw->priv;
> -
> -       priv = hw->priv;
>        IWL_DEBUG_MAC80211("enter\n");
>        IWL_DEBUG_MAC80211("leave\n");
>
> @@ -3558,9 +3555,6 @@ static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
>
>  static u64 iwl4965_mac_get_tsf(struct ieee80211_hw *hw)
>  {
> -       struct iwl_priv *priv;
> -
> -       priv = hw->priv;
>        IWL_DEBUG_MAC80211("enter\n");
>        IWL_DEBUG_MAC80211("leave\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

sorry have already some conflict patch in the pipe
Thank
Tomas
