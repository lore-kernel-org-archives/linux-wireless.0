Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:44533 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0K2JqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 04:46:21 -0500
Subject: Re: [PATCH v3] wl12xx: BA Initiator support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1290616180-16473-1-git-send-email-shahar_levi@ti.com>
References: <1290616180-16473-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:45:48 +0200
Message-ID: <1291023948.4284.4432.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 18:29 +0200, ext Shahar Levi wrote:
> Add 80211n BA initiator session support wl1271 driver.
> BA initiator session management included in FW independently.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index 75a6306..c511dce 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -1046,6 +1046,40 @@ struct wl1271_acx_ht_information {
>  	u8 padding[3];
>  } __packed;
>  
> +#define BA_RECEIVER_WIN_SIZE 8

This seems to be used only to configure the initiator mode window size,
so why is the macro called BA_RECEIVER_WIN_SIZE?


-Juuso

