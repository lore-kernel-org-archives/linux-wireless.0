Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:31466 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbcARJgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:36:11 -0500
Subject: Re: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc
 compilers
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1452958753-12307-1-git-send-email-aspriel@gmail.com>
 <8737tv7198.fsf@kamboji.qca.qualcomm.com>
 <CAMuHMdVq58-v4OED_A2X7c1f+C=h8H=en_maxHq9A+H_cHYXWA@mail.gmail.com>
 <CAMuHMdWoqFNWqFVF=eVtoRcWBqtbNW_cGPWDq5hNYB-rur-mOA@mail.gmail.com>
CC: Arend van Spriel <aspriel@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <569CB209.5080207@broadcom.com> (sfid-20160118_103619_544212_888B589F)
Date: Mon, 18 Jan 2016 10:36:09 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWoqFNWqFVF=eVtoRcWBqtbNW_cGPWDq5hNYB-rur-mOA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18-1-2016 10:27, Geert Uytterhoeven wrote:
> On Mon, Jan 18, 2016 at 10:08 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> (unfortunately) now up to the next one...
> 
> Please ignore. I used
> "make drivers/net/wireless/broadcom/brcm80211/brcmfmac/", which didn't pick up
> 
>         subdir-ccflags-$(CONFIG_BRCMDBG)        += -DDEBUG
> 
> in drivers/net/wireless/broadcom/brcm80211/Makefile
> 
> It builds fine with doing a normal build.

I see. Was not sure whether "next one" meant "brcmfmac" or not.

Regards,
Arend

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
