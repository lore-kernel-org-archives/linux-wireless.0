Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63373 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbZKESkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:40:23 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 01/41] rt2800usb: make Kconfig help entry more helpful
Date: Thu, 5 Nov 2009 19:40:24 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173158.28463.66661.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173158.28463.66661.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051940.24841.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: make Kconfig help entry more helpful
> 
> Document known issues with the driver to aid distribution makers,
> users and developers in making informed decisions instead of wasting
> their time needlessly.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> This reflects the actual state of affairs for driver in Linus' tree.
> 
>  drivers/net/wireless/rt2x00/Kconfig |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/Kconfig
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -104,7 +104,7 @@ config RT73USB
>  	  When compiled as a module, this driver will be called rt73usb.
>  
>  config RT2800USB
> -	tristate "Ralink rt2800 (USB) support"
> +	tristate "Ralink rt2800 (USB) support (EXPERIMENTAL)"
>  	depends on USB && EXPERIMENTAL
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_HT
> @@ -115,6 +115,10 @@ config RT2800USB
>  	  This adds experimental support for rt2800 wireless chipset family.
>  	  Supported chips: RT2770, RT2870 & RT3070.
>  
> +	  Known issues:
> +	  - support for RT2870 chips doesn't work with 802.11n APs yet
> +	  - support for RT3070 chips is non-functional at the moment
> +
>  	  When compiled as a module, this driver will be called "rt2800usb.ko".
>  
>  config RT2X00_LIB_PCI
> 


