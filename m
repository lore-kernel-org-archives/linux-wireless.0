Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42369 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2LBP2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 10:28:07 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so1070427vcd.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 07:28:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354460009-28449-3-git-send-email-juhosg@openwrt.org>
References: <1354460009-28449-1-git-send-email-juhosg@openwrt.org>
	<1354460009-28449-3-git-send-email-juhosg@openwrt.org>
Date: Sun, 2 Dec 2012 16:28:06 +0100
Message-ID: <CAOZOX0X4tDVtHHBOWAKaB5qCz3wMbC8mj6w7uVzVs985omSMxw@mail.gmail.com> (sfid-20121202_162814_462535_18190FF4)
Subject: Re: [PATCH 2/2] rt2x00: rt2800lib: fix indentation in rt2800_init_rfcsr
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The patch contains no functional changes.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |  120 +++++++++++++++----------------
>  1 file changed, 60 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 3d7b74e..1cc6599 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4220,66 +4220,66 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                         rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
>                 rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
>                 rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
> -       }       else if (rt2x00_rt(rt2x00dev, RT5392)) {
> -                       rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
> -                       rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> -                       rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> -                       rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
> -                       rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> -                       rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> -                       rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> -                       rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
> -                       rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> -                       rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
> -                       rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
> -                       rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
> -                       rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> -                       rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
> -                       rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
> -                       rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
> -                       rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
> -                       rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> -                       rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> -                       rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
> -                       rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> -                       rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
> -                       rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
> -                       rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
> -                       rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> -                       rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
> -                       rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
> -                       rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> -                       rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
> -                       rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> -                       rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
> -                       rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
> -                       rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> -                       rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> -                       rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> -                       rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
> -                       rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> -                       rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
> -                       rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
> -                       rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
> -                       rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
> -                       rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
> -                       rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
> -                       rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
> -                       rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
> -                       rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
> -                       rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
> -                       rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
> -                       rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> -                       rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
> -                       rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
> -                       rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
> +       } else if (rt2x00_rt(rt2x00dev, RT5392)) {
> +               rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
> +               rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> +               rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
> +               rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> +               rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> +               rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> +               rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
> +               rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> +               rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
> +               rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
> +               rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
> +               rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> +               rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
> +               rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
> +               rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
> +               rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> +               rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> +               rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
> +               rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> +               rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
> +               rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
> +               rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
> +               rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> +               rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
> +               rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
> +               rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> +               rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
> +               rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> +               rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
> +               rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
> +               rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> +               rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> +               rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> +               rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
> +               rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> +               rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
> +               rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
> +               rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
> +               rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
> +               rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
> +               rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
> +               rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
> +               rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
> +               rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
> +               rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
> +               rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
> +               rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> +               rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
> +               rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
> +               rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
>         }
>
>         if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
