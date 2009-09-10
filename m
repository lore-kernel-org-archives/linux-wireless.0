Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63122 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZIJFBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 01:01:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 22:01:16 -0700
Date: Thu, 10 Sep 2009 10:31:07 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 09/15] ath9k: remove unused bt_duty_cycle
Message-ID: <20090910050106.GH4166@vasanth-laptop>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com> <1252539901-20679-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1252539901-20679-10-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 05:14:55AM +0530, Luis Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/btcoex.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
> index d932f01..72c613d 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.h
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.h
> @@ -61,7 +61,6 @@ struct ath_btcoex_info {
>         u8 wlanactive_gpio;
>         u8 btactive_gpio;
>         u8 btpriority_gpio;
> -       u8 bt_duty_cycle;       /* BT duty cycle in percentage */
>         u32 bt_coex_mode;       /* Register setting for AR_BT_COEX_MODE */
>         u32 bt_coex_weights;    /* Register setting for AR_BT_COEX_WEIGHT */
>         u32 bt_coex_mode2;      /* Register setting for AR_BT_COEX_MODE2 */
> --

thanks.

Vasanth
