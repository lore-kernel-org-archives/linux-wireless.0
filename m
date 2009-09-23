Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33065 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZIWAoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 20:44:17 -0400
Subject: Re: [PATCH 3/3] i2400m-sdio: select IWMC3200TOP in Kconfig
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, yi.zhu@intel.com,
	inaky.perez-gonzalez@intel.com, cindy.h.kao@intel.com,
	guy.cohen@intel.com, ron.rindjunsky@intel.com
In-Reply-To: <1253662724-16497-4-git-send-email-tomas.winkler@intel.com>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-3-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-4-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 17:44:04 -0700
Message-Id: <1253666644.2931.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> i2400m-sdio requires iwmc3200top for its operation
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wimax/i2400m/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/Kconfig b/drivers/net/wimax/i2400m/Kconfig
> index d623b3d..7368ad5 100644
> --- a/drivers/net/wimax/i2400m/Kconfig
> +++ b/drivers/net/wimax/i2400m/Kconfig
> @@ -25,6 +25,7 @@ config WIMAX_I2400M_SDIO
>  	tristate "Intel Wireless WiMAX Connection 2400 over SDIO"
>  	depends on WIMAX && MMC
>  	select WIMAX_I2400M
> +	select IWMC3200TOP
>  	help
>  	  Select if you have a device based on the Intel WiMAX
>  	  Connection 2400 over SDIO.

this is not true actually. Since the WiMAX hardware in my laptop doesn't
require the top driver.

Regards

Marcel


