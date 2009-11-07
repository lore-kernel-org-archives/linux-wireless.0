Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39602 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbZKGX6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 18:58:13 -0500
Subject: Re: [PATCH 53/75] orinoco: declare MODULE_FIRMWARE
From: Pavel Roskin <proski@gnu.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: John Linville <linville@tuxdriver.com>,
	David Gibson <hermes@gibson.dropbear.id.au>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1257631289.15927.467.camel@localhost>
References: <1257631289.15927.467.camel@localhost>
Content-Type: text/plain
Date: Sat, 07 Nov 2009 18:58:15 -0500
Message-Id: <1257638295.3035.0.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-11-07 at 22:01 +0000, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Signed-off-by: Pavel Roskin <proski@gnu.org>

> ---
>  drivers/net/wireless/orinoco/fw.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
> index 1257250..cfa7296 100644
> --- a/drivers/net/wireless/orinoco/fw.c
> +++ b/drivers/net/wireless/orinoco/fw.c
> @@ -28,6 +28,12 @@ static const struct fw_info orinoco_fw[] = {
>  	{ NULL, "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
>  	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", NULL, 0x00003100, 512 }
>  };
> +MODULE_FIRMWARE("agere_sta_fw.bin");
> +MODULE_FIRMWARE("agere_ap_fw.bin");
> +MODULE_FIRMWARE("prism_sta_fw.bin");
> +MODULE_FIRMWARE("prism_ap_fw.bin");
> +MODULE_FIRMWARE("symbol_sp24t_prim_fw");
> +MODULE_FIRMWARE("symbol_sp24t_sec_fw");
>  
>  /* Structure used to access fields in FW
>   * Make sure LE decoding macros are used
-- 
Regards,
Pavel Roskin
