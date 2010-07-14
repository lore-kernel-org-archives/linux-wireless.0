Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab0GNPZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 11:25:49 -0400
Subject: Re: [PATCH] iwlwifi: convert new uses of __attribute__ ((packed))
 to __packed
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1279118252-10258-1-git-send-email-linville@tuxdriver.com>
References: <1279118252-10258-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 Jul 2010 08:25:11 -0700
Message-Id: <1279121111.19725.25.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-07-14 at 07:37 -0700, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
> index 8d2db9d..f1c0e68 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-commands.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
> @@ -1245,7 +1245,7 @@ struct iwl_txfifo_flush_cmd {
>  	__le32 fifo_control;
>  	__le16 flush_control;
>  	__le16 reserved;
> -} __attribute__ ((packed));
> +} __packed;
>  
>  /*
>   * REPLY_WEP_KEY = 0x20
> @@ -3547,7 +3547,7 @@ struct iwl_sensitivity_cmd {
>  struct iwl_enhance_sensitivity_cmd {
>  	__le16 control;			/* always use "1" */
>  	__le16 enhance_table[ENHANCE_HD_TABLE_SIZE];	/* use HD_* as index */
> -} __attribute__ ((packed));
> +} __packed;
>  
> 
>  /**

Thanks
Wey

