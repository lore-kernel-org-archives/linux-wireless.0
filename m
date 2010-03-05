Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34346 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0CERax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 12:30:53 -0500
Received: by gyg10 with SMTP id 10so3018gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 09:30:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003051744.22521.helmut.schaa@googlemail.com>
References: <201003051744.22521.helmut.schaa@googlemail.com>
Date: Fri, 5 Mar 2010 18:30:52 +0100
Message-ID: <14add3d11003050930q65b90d11pc5d17eeb15ad4709@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: remove KSEG1ADDR define from rt2x00soc.h
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 5, 2010 at 5:44 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Remove the KSEG1ADDR define from rt2x00soc.h as it redefines and covers the
> correct one from the arch/mips/include/asm/addrspace.h. Otherwise the driver
> oopses on the target platform (Ralink rt3050 board).
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

>
>  drivers/net/wireless/rt2x00/rt2x00soc.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
> index 4739edf..474cbfc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
> @@ -26,8 +26,6 @@
>  #ifndef RT2X00SOC_H
>  #define RT2X00SOC_H
>
> -#define KSEG1ADDR(__ptr) __ptr
> -
>  /*
>  * SoC driver handlers.
>  */
> --
> 1.6.0.2
>
>
