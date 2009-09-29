Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZI2JWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 05:22:52 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: select IWMC3200TOP in Kconfig
From: Zhu Yi <yi.zhu@intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	"Kao, Cindy H" <cindy.h.kao@intel.com>,
	"Cohen, Guy" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1253662724-16497-3-git-send-email-tomas.winkler@intel.com>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 17:22:43 +0800
Message-Id: <1254216163.3731.36.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-23 at 07:38 +0800, Winkler, Tomas wrote:
> iwmc3200wifi requires iwmc3200top  for its operation
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

> ---
>  drivers/net/wireless/iwmc3200wifi/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
> index c62da43..69faaf1 100644
> --- a/drivers/net/wireless/iwmc3200wifi/Kconfig
> +++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
> @@ -3,6 +3,7 @@ config IWM
>  	depends on MMC && WLAN_80211 && EXPERIMENTAL
>  	depends on CFG80211
>  	select FW_LOADER
> +	select IWMC3200TOP
>  	help
>  	  The Intel Wireless Multicomm 3200 hardware is a combo
>  	  card with GPS, Bluetooth, WiMax and 802.11 radios. It

