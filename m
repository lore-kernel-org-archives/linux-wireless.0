Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:17662 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761594AbYDBURU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:17:20 -0400
Received: by rn-out-0910.google.com with SMTP id e24so1808967rng.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 13:17:18 -0700 (PDT)
Message-ID: <1ba2fa240804021317v1ffc4d0br856ae6657683b656@mail.gmail.com> (sfid-20080402_211743_159836_CFF51331)
Date: Wed, 2 Apr 2008 23:17:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Reinette Chatre" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: fix incorrect config variable
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1207154358-29025-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207154358-29025-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 2, 2008 at 7:39 PM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>  ---
>   drivers/net/wireless/iwlwifi/iwl-3945.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
>  diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
>  index ac12269..8114d05 100644
>  --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
>  +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
>  @@ -779,7 +779,7 @@ struct iwl3945_priv {
>         struct iwl3945_init_alive_resp card_alive_init;
>         struct iwl3945_alive_resp card_alive;
>
>  -#ifdef CONFIG_IWL4965_LEDS
>  +#ifdef CONFIG_IWL3945_LEDS
>         struct iwl3945_led led[IWL_LED_TRG_MAX];
>         unsigned long last_blink_time;
>         u8 last_blink_rate;


How this one slipped out from the original patch?!
Tomas
ACK
>
>
>  -------------------------------------------------------------------------
>  Check out the new SourceForge.net Marketplace.
>  It's the best place to buy or sell services for
>  just about anything Open Source.
>  http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
>  _______________________________________________
>  Ipw3945-devel mailing list
>  Ipw3945-devel@lists.sourceforge.net
>  https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
