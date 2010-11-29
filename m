Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35795 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2MeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:34:07 -0500
Message-ID: <4CF39DBA.2020004@ti.com>
Date: Mon, 29 Nov 2010 14:34:02 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl12xx: Remove 11j channels from the supported channels
 list.
References: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 12:05 PM, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>
> Because we don't support them at this stage.
>
> Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> ---
>   drivers/net/wireless/wl12xx/main.c |    8 --------
>   1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 7fecefe..dc3a093 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
>
>   /* 5 GHz band channels for WL1273 */
>   static struct ieee80211_channel wl1271_channels_5ghz[] = {
> -	{ .hw_value = 183, .center_freq = 4915},
> -	{ .hw_value = 184, .center_freq = 4920},
> -	{ .hw_value = 185, .center_freq = 4925},
> -	{ .hw_value = 187, .center_freq = 4935},
> -	{ .hw_value = 188, .center_freq = 4940},
> -	{ .hw_value = 189, .center_freq = 4945},
> -	{ .hw_value = 192, .center_freq = 4960},
> -	{ .hw_value = 196, .center_freq = 4980},
>   	{ .hw_value = 7, .center_freq = 5035},
>   	{ .hw_value = 8, .center_freq = 5040},
>   	{ .hw_value = 9, .center_freq = 5045},
Our firmware do supports Japan channels, so why to remove them?
