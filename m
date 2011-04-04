Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1DDRVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:21:19 -0400
Subject: Re: [PATCH] iwlwifi: accept EEPROM version 0x423 for iwl6000
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1301937524-6860-1-git-send-email-linville@tuxdriver.com>
References: <1301937524-6860-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:02:24 -0700
Message-ID: <1301936544.14995.102.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 10:18 -0700, John W. Linville wrote:
> A number of these devices have appeared "in the wild", and apparently
> the Windows driver is perfectly happy to support this EEPROM version.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: stable@kernel.org
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
> index 98aa8af..20b6646 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
> @@ -241,7 +241,7 @@ struct iwl_eeprom_enhanced_txpwr {
>  
>  /* 6x00 Specific */
>  #define EEPROM_6000_TX_POWER_VERSION    (4)
> -#define EEPROM_6000_EEPROM_VERSION	(0x434)
> +#define EEPROM_6000_EEPROM_VERSION	(0x423)
>  
>  /* 6x50 Specific */
>  #define EEPROM_6050_TX_POWER_VERSION    (4)


