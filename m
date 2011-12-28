Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39091 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab1L1UMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:12:41 -0500
Received: by vbbfc26 with SMTP id fc26so9835525vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:12:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-8-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-4-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-5-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-6-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-7-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-8-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 21:12:40 +0100
Message-ID: <CAOZOX0VAvsS=YiEtpWW+4arzPo5RcEaSA_KpC-w0vCm3-uWsmw@mail.gmail.com> (sfid-20111228_211243_647473_B7F70A63)
Subject: Re: [PATCH 7/7] rt2x00: Change RF3853 to RF3053.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> According to the latest Ralink vendor drivers, this seems to be the real
> RF chipset type.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 4778620..2571a2f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -50,7 +50,7 @@
>  * RF2853 2.4G/5G 3T3R
>  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
>  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
> - * RF3853 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
> + * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
>  * RF5370 2.4G 1T1R
>  * RF5390 2.4G 1T1R
>  */
> @@ -66,7 +66,7 @@
>  #define RF2853                         0x000a
>  #define RF3320                         0x000b
>  #define RF3322                         0x000c
> -#define RF3853                         0x000d
> +#define RF3053                         0x000d
>  #define RF5370                         0x5370
>  #define RF5390                         0x5390
>
> --
> 1.7.7.4
>
