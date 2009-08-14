Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:52312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbZHNKNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 06:13:30 -0400
Received: by fg-out-1718.google.com with SMTP id e12so50611fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 03:13:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250210584-13374-12-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
	<1250210584-13374-12-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 12:13:10 +0200
Message-ID: <69e28c910908140313p7d138635q51ee71c362aaa7f6@mail.gmail.com>
Subject: Re: [PATCH v2 11/25] wireless: clarify rndis_wlan is not broadcom
	specific
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 2:42 AM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Gábor Stefanik <netrolller.3d@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/Kconfig |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index cb5aae6..a1bdb51 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -403,7 +403,9 @@ config USB_NET_RNDIS_WLAN
>          BUFFALO WLI-USB-G54
>
>          All of these devices are based on Broadcom 4320 chip which is the
> -         only wireless RNDIS chip known to date.
> +         only wireless RNDIS chip known to date. Technically RNDIS follows
> +         a specification and although only Broadcom currently supports this
> +         other vendors could technically follow the implementation as well.

To the aforementioned "other vendors" - please do not follow this
brain-dead, Microsoft-based spec! :-)

BTW, there are a few missing commas in the 3rd added line:
"a specification, and although only Broadcom currently support this,"
would be better.

>
>          If you choose to build a module, it'll be called rndis_wlan.
>
> --
> 1.6.2.5
>
>


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
