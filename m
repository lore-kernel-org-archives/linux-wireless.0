Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61822 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1AVByZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 20:54:25 -0500
Received: by qyk12 with SMTP id 12so2586256qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 17:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295654809-5790-8-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com> <1295654809-5790-8-git-send-email-wey-yi.w.guy@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Jan 2011 02:54:04 +0100
Message-ID: <AANLkTi=uSBys=51Gin=-ck7dyPUYgWE1yLAHQ2ofV+K7@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 07/14] iwlagn: remove Gen2 from Kconfig
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 22, 2011 at 1:06 AM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> Remove Gen 2 from Kconfig file since 6005/6030/6150 series of
> products are released.
>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/Kconfig |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> index 442a146..236f900 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -110,8 +110,9 @@ config IWL5000
>                Intel WiFi Link 1000BGN
>                Intel Wireless WiFi 5150AGN
>                Intel Wireless WiFi 5100AGN, 5300AGN, and 5350AGN
> -               Intel 6000 Gen 2 Series Wi-Fi Adapters (6000G2A and 6000G2B)
> -               Intel WIreless WiFi Link 6050BGN Gen 2 Adapter
> +               Intel 6005 Series Wi-Fi Adapters
> +               Intel 6030 Series Wi-Fi Adapters
> +               Intel Wireless WiFi Link 6150BGN 2 Adapter

Shouldn't this be "Intel Centrino Advanced-N 6150 Adapter"?

>                Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
>                Intel 2000 Series Wi-Fi Adapters
>
> --
> 1.7.0.4
>
>
> ------------------------------------------------------------------------------
> Special Offer-- Download ArcSight Logger for FREE (a $49 USD value)!
> Finally, a world-class log management solution at an even better price-free!
> Download using promo code Free_Logger_4_Dev2Dev. Offer expires
> February 28th, so secure your free ArcSight Logger TODAY!
> http://p.sf.net/sfu/arcsight-sfd2d
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
