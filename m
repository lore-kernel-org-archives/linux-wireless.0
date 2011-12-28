Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63479 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1L1UM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:12:26 -0500
Received: by vcbfk14 with SMTP id fk14so9715858vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:12:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-7-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-4-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-5-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-6-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-7-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 21:12:25 +0100
Message-ID: <CAOZOX0V4CS14MA4=1vyBLWB_d5+598c__xKEXGqD5skMno7HUQ@mail.gmail.com> (sfid-20111228_211228_637347_18E63A8E)
Subject: Re: [PATCH 6/7] rt2x00: RT3593 is also applicable to USB.
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
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 851b717..b03b22c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -189,7 +189,7 @@ struct rt2x00_chip {
>  #define RT3090         0x3090  /* 2.4GHz PCIe */
>  #define RT3390         0x3390
>  #define RT3572         0x3572
> -#define RT3593         0x3593  /* PCIe */
> +#define RT3593         0x3593
>  #define RT3883         0x3883  /* WSOC */
>  #define RT5390         0x5390  /* 2.4GHz */
>
> --
> 1.7.7.4
>
