Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:60771 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0LVVgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:36:24 -0500
Subject: Re: [PATCH v2 08/18] wl1271: Add AP related definitions to HOST-FW
 interface
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-9-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-9-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 23:36:22 +0200
Message-ID: <1293053782.14423.51.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Change structures in a non-destructive manner. This means no
> changes in size or location of existing members used by STA.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
> index 3abb26f..19fd591 100644
> --- a/drivers/net/wireless/wl12xx/rx.h
> +++ b/drivers/net/wireless/wl12xx/rx.h
> @@ -86,10 +86,11 @@
>  /*
>   * RX Descriptor status
>   *
> - * Bits 0-2 - status
> - * Bits 3-7 - reserved
> + * Bits 0-2 - error code
> + * Bits 3-5 - process_id tag (AP mode FW)
> + * Bits 6-7 - reserved
>   */
> -#define WL1271_RX_DESC_STATUS_MASK      0x07
> +#define WL1271_RX_DESC_STATUS_MASK      0x03

What happened with bit 2?


-- 
Cheers,
Luca.

