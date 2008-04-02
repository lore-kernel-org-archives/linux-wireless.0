Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:45609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138AbYDBUnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:43:14 -0400
Received: by ug-out-1314.google.com with SMTP id z38so538621ugc.16
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 13:43:10 -0700 (PDT)
Message-ID: <1ba2fa240804021343v5be6da1dp2a5e3c813f41495f@mail.gmail.com> (sfid-20080402_214321_225451_F986AC23)
Date: Wed, 2 Apr 2008 23:43:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: fix incorrect config variable
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB0892004194A10@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207154358-29025-1-git-send-email-reinette.chatre@intel.com>
	 <1ba2fa240804021317v1ffc4d0br856ae6657683b656@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004194A10@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 2, 2008 at 11:34 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
> On Wednesday, April 02, 2008 1:17 PM, Tomas Winkler  wrote:
>
>  > On Wed, Apr 2, 2008 at 7:39 PM, Reinette Chatre
>  > <reinette.chatre@intel.com> wrote:
>  >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>  ---
>  >>   drivers/net/wireless/iwlwifi/iwl-3945.h |    2 +-
>  >>   1 files changed, 1 insertions(+), 1 deletions(-)
>  >>
>  >>  diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
>  > b/drivers/net/wireless/iwlwifi/iwl-3945.h
>  >>  index ac12269..8114d05 100644
>  >>  --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
>  >>  +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
>  >>  @@ -779,7 +779,7 @@ struct iwl3945_priv {
>  >>         struct iwl3945_init_alive_resp card_alive_init;
>  >>         struct iwl3945_alive_resp card_alive;
>  >>
>  >>  -#ifdef CONFIG_IWL4965_LEDS
>  >>  +#ifdef CONFIG_IWL3945_LEDS
>  >>         struct iwl3945_led led[IWL_LED_TRG_MAX];
>  >>         unsigned long last_blink_time;
>  >>         u8 last_blink_rate;
>  >
>  >
>  > How this one slipped out from the original patch?!
>  > Tomas
>  > ACK
>
>  My fault - sorry.

Errare humanum est :)

>  Reinette
>
