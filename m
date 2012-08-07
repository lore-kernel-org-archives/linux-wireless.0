Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:40772 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290Ab2HGCfs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 22:35:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 6 Aug 2012 19:35:11 -0700
Subject: RE: [PATCH] mwifiex: fix code mis-alignment after the if statement
Message-ID: <477F20668A386D41ADCC57781B1F7043083AE3DA2D@SC-VEXCH1.marvell.com> (sfid-20120807_043552_070071_9BC2CAEF)
References: <20120807022653.GA21014@localhost>
In-Reply-To: <20120807022653.GA21014@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fengguang,

Thanks for the patch.

> Subject: [PATCH] mwifiex: fix code mis-alignment after the if statement
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/scan.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux.orig/drivers/net/wireless/mwifiex/scan.c	2012-07-25 19:09:37.939358714 +0800
> +++ linux/drivers/net/wireless/mwifiex/scan.c	2012-08-07 10:21:20.303090255 +0800
> @@ -1433,9 +1433,9 @@ int mwifiex_check_network_compatibility(
>  			if (ret)
>  				dev_err(priv->adapter->dev, "cannot find ssid "
>  					"%s\n", bss_desc->ssid.ssid);
> -				break;
> +			break;
>  		default:
> -				ret = 0;
> +			ret = 0;
>  		}
>  	}
> 
