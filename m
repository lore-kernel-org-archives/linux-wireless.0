Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37551 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbcBBW0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 17:26:21 -0500
Received: by mail-ig0-f171.google.com with SMTP id 5so22685100igt.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 14:26:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454416992-7400-1-git-send-email-rakhish1994@gmail.com>
References: <1454416992-7400-1-git-send-email-rakhish1994@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Feb 2016 09:26:01 +1100
Message-ID: <CAGRGNgV7zFMLXfGU=azT6J2jo10MXH==qQJw+kRz8a5GOVjGig@mail.gmail.com> (sfid-20160202_232624_457184_CFACED8E)
Subject: Re: [PATCH] Staging: rtl8723au: core: rtw_ieee80211: Fixed a coding
 style Warning.
To: Rakhi Sharma <rakhish1994@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rakhi,

On Tue, Feb 2, 2016 at 11:43 PM, Rakhi Sharma <rakhish1994@gmail.com> wrote:
> Fixed a braces style warning.
> Warning: braces {} are not necessary for single statement blocks.
>
> Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>

Looks good.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> index 07a6490..5089ae8 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> @@ -176,10 +176,8 @@ u8 *rtw_get_ie23a(u8 *pbuf, int index, int *len, int limit)
>         int tmp, i;
>         u8 *p;
>
> -       if (limit < 1) {
> -
> +       if (limit < 1)
>                 return NULL;
> -       }
>
>         p = pbuf;
>         i = 0;
> --
> 1.9.1
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
