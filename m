Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49840 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1L1UK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:10:56 -0500
Received: by mail-vx0-f174.google.com with SMTP id fk14so9714904vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:10:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-3-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 21:10:55 +0100
Message-ID: <CAOZOX0VhJ9wLHEsUa=p00tHO-38JwkyLYjG9DXq+vtcOa9DxBA@mail.gmail.com> (sfid-20111228_211059_106516_2E9DBD58)
Subject: Re: [PATCH 2/7] rt2x00: Whitespace cleanup.
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
> index 99ff12d..851b717 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -191,7 +191,7 @@ struct rt2x00_chip {
>  #define RT3572         0x3572
>  #define RT3593         0x3593  /* PCIe */
>  #define RT3883         0x3883  /* WSOC */
> -#define RT5390         0x5390  /* 2.4GHz */
> +#define RT5390         0x5390  /* 2.4GHz */
>
>        u16 rf;
>        u16 rev;
> --
> 1.7.7.4
>
