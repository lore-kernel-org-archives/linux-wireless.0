Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:53731 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750872AbdLAJmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 04:42:21 -0500
Message-ID: <1512121337.19952.154.camel@perches.com> (sfid-20171201_104245_874709_AD4AEBB0)
Subject: Re: [PATCH] wlcore, wl1251: fix spelling mistake: "Couldnt" ->
 "Couldn't"
From: Joe Perches <joe@perches.com>
To: Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Dec 2017 01:42:17 -0800
In-Reply-To: <20171201093433.9154-1-colin.king@canonical.com>
References: <20171201093433.9154-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 09:34 +0000, Colin King wrote:
> Trivial fix to spelling mistake in error message text.
[]
> diff --git a/drivers/net/wireless/ti/wl1251/init.c b/drivers/net/wireless/ti/wl1251/init.c
[]
> @@ -311,7 +311,7 @@ static int wl1251_hw_init_data_path_config(struct wl1251 *wl)
>  	wl->data_path = kzalloc(sizeof(struct acx_data_path_params_resp),
>  				GFP_KERNEL);
>  	if (!wl->data_path) {
> -		wl1251_error("Couldnt allocate data path parameters");
> +		wl1251_error("Couldn't allocate data path parameters");

Might be better to remove this one.
