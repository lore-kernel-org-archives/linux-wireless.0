Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:35406 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab2KOXUo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 18:20:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 15 Nov 2012 15:18:20 -0800
Subject: RE: [PATCH] mwifiex: don't select lib80211
Message-ID: <477F20668A386D41ADCC57781B1F7043083BCC29DB@SC-VEXCH1.marvell.com> (sfid-20121116_002047_540061_7D3CD661)
References: <1353020720-5228-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1353020720-5228-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The driver doesn't use any lib80211 symbols
> so it shouldn't select it in Kconfig.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
> index 8e384fa..b2e2772 100644
> --- a/drivers/net/wireless/mwifiex/Kconfig
> +++ b/drivers/net/wireless/mwifiex/Kconfig
> @@ -1,7 +1,6 @@
>  config MWIFIEX
>  	tristate "Marvell WiFi-Ex Driver"
>  	depends on CFG80211
> -	select LIB80211
>  	---help---
>  	  This adds support for wireless adapters based on Marvell
>  	  802.11n chipsets.
> --
> 1.8.0

