Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:53635 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0LVUoY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:44:24 -0500
Subject: Re: [PATCH v2 02/18] wl1271: AP mode - AP specific CMD_CONFIGURE
 sub-commands
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-3-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 22:44:20 +0200
Message-ID: <1293050660.14423.20.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Add AP max retries and rate policy configuration.
> Rename STA rate policy configuration function.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index 9cbc3f4..d2a68bf 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h

[...]

> +	__le32 rate_policy_idx; /* The index of the rate policy */

This comment is quite useless. ;)


> @@ -1062,6 +1072,19 @@ struct wl1271_acx_fw_tsf_information {
>  	u8 padding[3];
>  } __packed;
>  
> +#define WL1271_AP_MAX_TX_RETRY   100

Should this be part of the conf.h settings? Should it be made more
easily configurable?


-- 
Cheers,
Luca.

