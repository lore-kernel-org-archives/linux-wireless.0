Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41724 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0ABQ1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:27:16 -0500
Received: by fxm25 with SMTP id 25so7706233fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 08:27:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.u5wyi5dd9lhzdc@linux-g0th.site>
References: <op.u5wyi5dd9lhzdc@linux-g0th.site>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 2 Jan 2010 17:26:55 +0100
Message-ID: <69e28c911001020826q575f65fbp6b48232e83392dcb@mail.gmail.com>
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/2 Rafał Miłecki <zajec5@gmail.com>:
> Finally I've possibility to test my Christmas-gift N-PHY :) b43 didn't
> really "notice" it, so I needed to write this little patch. Now b43 at least
> look for firmware for my card.
>
> Does this patch look OK?
>
> This time I post from Opera mail so I hope white-spaces will be fine.
>
> From 9b3ea4f29b038f732aba737323e2f89b275ce1ab Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
> Date: Sat, 2 Jan 2010 16:58:16 +0100
> Subject: [PATCH] b43: Add new SSB's core id for BCM4328
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> Following line shows my BCM4328 detected on SSB. We didn't include 0x0C rev.
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index 098dda1..3aa45b8 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
> +       SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),

Rev.14 is also missing (which AFAIK is used by some LP cards).

>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 15),
>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
> --
> 1.6.4.2



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
