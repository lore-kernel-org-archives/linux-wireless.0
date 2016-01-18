Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35495 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbcARJ1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:27:11 -0500
Received: by mail-ig0-f181.google.com with SMTP id t15so51621079igr.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 01:27:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVq58-v4OED_A2X7c1f+C=h8H=en_maxHq9A+H_cHYXWA@mail.gmail.com>
References: <1452958753-12307-1-git-send-email-aspriel@gmail.com>
	<8737tv7198.fsf@kamboji.qca.qualcomm.com>
	<CAMuHMdVq58-v4OED_A2X7c1f+C=h8H=en_maxHq9A+H_cHYXWA@mail.gmail.com>
Date: Mon, 18 Jan 2016 10:27:10 +0100
Message-ID: <CAMuHMdWoqFNWqFVF=eVtoRcWBqtbNW_cGPWDq5hNYB-rur-mOA@mail.gmail.com> (sfid-20160118_102728_321238_54FD1341)
Subject: Re: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc compilers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <aspriel@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2016 at 10:08 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> (unfortunately) now up to the next one...

Please ignore. I used
"make drivers/net/wireless/broadcom/brcm80211/brcmfmac/", which didn't pick up

        subdir-ccflags-$(CONFIG_BRCMDBG)        += -DDEBUG

in drivers/net/wireless/broadcom/brcm80211/Makefile

It builds fine with doing a normal build.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
