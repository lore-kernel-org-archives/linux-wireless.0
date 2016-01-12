Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:36006 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759155AbcALBAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 20:00:22 -0500
Message-ID: <1452560419.7773.87.camel@perches.com> (sfid-20160112_020026_783706_E317C47B)
Subject: Re: [PATCH 2/5] staging: wilc1000: remove typedef from struct
 wilc_cfg_byte_t
From: Joe Perches <joe@perches.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>, gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 11 Jan 2016 17:00:19 -0800
In-Reply-To: <1452558775-21532-2-git-send-email-chaehyun.lim@gmail.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
	 <1452558775-21532-2-git-send-email-chaehyun.lim@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-12 at 09:32 +0900, Chaehyun Lim wrote:
> This patch removes typedef from struct wilc_cfg_byte_t and renames it to
> wilc_cfg_byte.

Is this really a good name?

> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
[]
> @@ -10,10 +10,10 @@
>  #ifndef WILC_WLAN_CFG_H
>  #define WILC_WLAN_CFG_H
>  
> -typedef struct {
> +struct wilc_cfg_byte {
>  	u16 id;
>  	u16 val;
> -} wilc_cfg_byte_t;
> +};

val is a u16, calling it cfg_byte seems misleading.


