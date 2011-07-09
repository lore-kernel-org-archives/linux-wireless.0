Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48377 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1GIPWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 11:22:14 -0400
Received: by qwk3 with SMTP id 3so1331603qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jul 2011 08:22:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110709145001.GA6938@notk.org>
References: <20110709145001.GA6938@notk.org>
Date: Sat, 9 Jul 2011 17:22:13 +0200
Message-ID: <CA+icZUWcVAmhd-t09FoYnnx+93sEBa9nT577g45OfwdaXTrvSg@mail.gmail.com> (sfid-20110709_172222_284251_3E7A7287)
Subject: Re: [PATCH 3.0.0-rc6] rt2x00: add Ralink 0x539f to PCI_DEVICE_TABLE
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Adrien Nader <adrien@notk.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First part already exists in wireless-next-2.6 GIT [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commitdiff;h=71e0b38c2914018b01f3f08b43ee9e3328197699

On Sat, Jul 9, 2011 at 4:50 PM, Adrien Nader <adrien@notk.org> wrote:
> Actual support for this card which is to be found in HP dm1* laptops is
> already there for the 5390. This only adds the device id to the list of
> hardware handled by the driver.
>
> Signed-off-by: Adrien Nader <adrien@notk.org>
> ---
> It also changes some spaces into tabs to be be consistent with the
> previous lines (it lined up correctly only if you have tabs set to 8
> spaces).
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index cc4a54f..55cd3e1 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1158,6 +1158,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  #endif
>  #ifdef CONFIG_RT2800PCI_RT53XX
>        { PCI_DEVICE(0x1814, 0x5390) },
> +       { PCI_DEVICE(0x1814, 0x539f) },
>  #endif
>        { 0, }
>  };
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index c446db6..5c5b6a8 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -190,7 +190,7 @@ struct rt2x00_chip {
>  #define RT3572         0x3572
>  #define RT3593         0x3593  /* PCIe */
>  #define RT3883         0x3883  /* WSOC */
> -#define RT5390         0x5390  /* 2.4GHz */
> +#define RT5390         0x5390  /* 2.4GHz */
>
>        u16 rf;
>        u16 rev;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
