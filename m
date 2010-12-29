Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:22723 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0L2JVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 04:21:52 -0500
Subject: Re: [PATCH v3 14/18] wl1271: AP mode - record TX configuration
 settings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293557808-27068-15-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
	 <1293557808-27068-15-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 11:21:48 +0200
Message-ID: <1293614508.15791.0.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 19:36 +0200, ext Arik Nemtsov wrote:
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c
> b/drivers/net/wireless/wl12xx/main.c
> index 3747d98..ea61ae7 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -1433,6 +1433,8 @@ static int wl1271_op_config(struct ieee80211_hw
> *hw, u32 changed)
>                 goto out;
>         }
>  
> +       is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
> +
>         ret = wl1271_ps_elp_wakeup(wl, false);
>         if (ret < 0)
>                 goto out; 

Did you forget to fix this one? As we discussed, this should be in
10/18.


-- 
Cheers,
Luca.

