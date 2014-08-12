Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHLCqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 22:46:06 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: [PATCH 2/2] iwlwifi: Remove module build requirement for Intel
 Wireless WiFi MVM
Date: Tue, 12 Aug 2014 02:46:01 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B251FB3@hasmsx107.ger.corp.intel.com> (sfid-20140812_044610_979110_D9D6AC3C)
References: <1407787896-52455-2-git-send-email-marcel@holtmann.org>
In-Reply-To: <1407787896-52455-2-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> The CONFIG_IWLMVM currently has a "depends on m" as its requirement
> forcing it to be build as module. This is not needed and thus just remove it.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  drivers/net/wireless/iwlwifi/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> b/drivers/net/wireless/iwlwifi/Kconfig
> index 9cc33e13690b..824f5e287783 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -59,7 +59,6 @@ config IWLDVM
> 
>  config IWLMVM
>  	tristate "Intel Wireless WiFi MVM Firmware support"
> -	depends on m
>  	help
>  	  This is the driver that supports the MVM firmware which is
>  	  currently only available for 7260 and 3160 devices.
> --
> 1.9.3

I'll apply these - thanks.
