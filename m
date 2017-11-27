Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:42941 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdK0KLT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 05:11:19 -0500
MIME-Version: 1.0
In-Reply-To: <1511776877-11130-1-git-send-email-geert@linux-m68k.org>
References: <1511776877-11130-1-git-send-email-geert@linux-m68k.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 27 Nov 2017 11:11:17 +0100
Message-ID: <CAMuHMdX6XpKbLYuwkdCK0YhYGaV5Sg8+v0DrUV9y6R3Qozf-qQ@mail.gmail.com> (sfid-20171127_111137_633116_E2FE9639)
Subject: Re: Build regressions/improvements in v4.15-rc1
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:01 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v4.15-rc1[1] compared to v4.14[2].
>
> Summarized:
>   - build errors: +2/-5

> [1] http://kisskb.ellerman.id.au/kisskb/head/4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323/ (all 271 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/bebc6082da0a9f5d47a1ea2edc099bf671058bd4/ (270 out of 271 configs)

> 2 error regressions:
>   + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_csr.c: error: 'si' may be used uninitialized in this function [-Werror=uninitialized]:  => 204:3

x86_64-randconfig

>   + /home/kisskb/slave/src/include/linux/bcma/bcma_driver_pci.h: error: field 'pci_controller' has incomplete type:  => 218:24

mips-allmodconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
