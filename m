Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41995 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab2IQP2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:28:13 -0400
Received: by dady13 with SMTP id y13so959801dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347827393-26948-5-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-2-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-3-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-4-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-5-git-send-email-gwingerde@gmail.com>
Date: Mon, 17 Sep 2012 17:28:13 +0200
Message-ID: <CAOZOX0XWrUiUNp1Ry62ptiVOWrJ-+O7o_VjiPHX0ep8zTdH6wQ@mail.gmail.com> (sfid-20120917_172821_546518_A1CACA62)
Subject: Re: [PATCH 4/5] rt2x00: Code style cleanup in rt2800lib.c
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 16, 2012 at 10:29 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 37f64ba..d745c32 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -3090,7 +3090,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>                 rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
>                 rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
>         } else if (rt2x00_rt(rt2x00dev, RT5390) ||
> -                          rt2x00_rt(rt2x00dev, RT5392)) {
> +                  rt2x00_rt(rt2x00dev, RT5392)) {
>                 rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>                 rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
>                 rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> --
> 1.7.11.1
>
