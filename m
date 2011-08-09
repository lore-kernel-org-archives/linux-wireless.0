Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:60288 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641Ab1HIL7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:59:31 -0400
Received: by eyg24 with SMTP id 24so3485551eyg.16
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 04:59:28 -0700 (PDT)
Subject: Re: [PATCH 02/40] wl12xx: Use a single fw for both STA and AP roles
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-3-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-3-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:59:25 +0300
Message-ID: <1312891165.2407.163.camel@cumari> (sfid-20110809_135934_548130_589A20EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> The new wl12xx fw supports both STA and AP roles.

Again, let's be more explicit here about the firmware versions.


> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 6c080e9..21c5f95 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -127,16 +127,14 @@ extern u32 wl12xx_debug_level;
>  				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN | \
>  				  CFG_RX_CTL_EN | CFG_RX_AUTH_EN | \
>  				  CFG_RX_ASSOC_EN)
>  
> 
> 
> -#define WL1271_FW_NAME "ti-connectivity/wl1271-fw-2.bin"
> -#define WL128X_FW_NAME "ti-connectivity/wl128x-fw.bin"
> -#define WL127X_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
> -#define WL128X_AP_FW_NAME "ti-connectivity/wl128x-fw-ap.bin"
> +#define WL1271_FW_NAME "ti-connectivity/wl1271-fw-3.bin"
> +#define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"

Should we use this opportunity to change the macro to WL127X_FW_NAME and
the file name to wl127x-fw.bin?


-- 
Cheers,
Luca.

