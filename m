Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36610 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab0HRVOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 17:14:41 -0400
Date: Wed, 18 Aug 2010 17:04:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Add support for bluetooth coexistence.
Message-ID: <20100818210423.GD2793@tuxdriver.com>
References: <1282141669-9823-1-git-send-email-vnatarajan@atheros.com>
 <1282141669-9823-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282141669-9823-2-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 07:57:49PM +0530, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  136 +++++++++++++++++++++++++

> +/*
> + * Cancel btcoex and bt duty cycle work.
> + */
> +void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
> +{
> +	cancel_delayed_work_sync(&priv->coex_period_work);
> +	cancel_delayed_work_sync(&priv->duty_cycle_work);
> +
> +}
> +

Please don't add blank lines at the ends of files...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
