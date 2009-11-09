Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZKIDdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:33:49 -0500
Subject: Re: [PATCH 48/75] ipw2200: declare MODULE_FIRMWARE
From: Zhu Yi <yi.zhu@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: John Linville <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1257631150.15927.458.camel@localhost>
References: <1257631150.15927.458.camel@localhost>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 11:33:29 +0800
Message-Id: <1257737609.5538.995.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-11-08 at 05:59 +0800, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/ipw2x00/ipw2200.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index e2af22b..d03ef19 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -81,6 +81,11 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
>  MODULE_VERSION(DRV_VERSION);
>  MODULE_AUTHOR(DRV_COPYRIGHT);
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE("ipw2200-ibss.fw");
> +#ifdef CONFIG_IPW2200_MONITOR
> +MODULE_FIRMWARE("ipw2200-sniffer.fw");
> +#endif
> +MODULE_FIRMWARE("ipw2200-bss.fw");
>  
>  static int cmdlog = 0;
>  static int debug = 0;

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

