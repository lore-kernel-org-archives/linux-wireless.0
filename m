Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40139 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0K2MHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:07:10 -0500
Received: by qyk11 with SMTP id 11so10756559qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 04:07:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 29 Nov 2010 13:06:47 +0100
Message-ID: <AANLkTikqg4+ERD6V+7P=2R_H2Q9bWuW3Jz6F=Kp4YKSC@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Remove 11j channels from the supported channels list.
To: juuso.oikarinen@nokia.com
Cc: luciano.coelho@nokia.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 11:05 AM,  <juuso.oikarinen@nokia.com> wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>
> Because we don't support them at this stage.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 7fecefe..dc3a093 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
>
>  /* 5 GHz band channels for WL1273 */
>  static struct ieee80211_channel wl1271_channels_5ghz[] = {

Is this for WL1271 or WL1273? The comment contradicts the name...

> -       { .hw_value = 183, .center_freq = 4915},
> -       { .hw_value = 184, .center_freq = 4920},
> -       { .hw_value = 185, .center_freq = 4925},
> -       { .hw_value = 187, .center_freq = 4935},
> -       { .hw_value = 188, .center_freq = 4940},
> -       { .hw_value = 189, .center_freq = 4945},
> -       { .hw_value = 192, .center_freq = 4960},
> -       { .hw_value = 196, .center_freq = 4980},
>        { .hw_value = 7, .center_freq = 5035},
>        { .hw_value = 8, .center_freq = 5040},
>        { .hw_value = 9, .center_freq = 5045},
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
