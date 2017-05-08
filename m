Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33502 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752980AbdEHOmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 10:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <40c81df4-d17f-c374-e5a8-c5b8edd914b5@gmail.com>
References: <b4a25189-3e3e-a051-70c3-7fbedc366a26@gmail.com>
 <8b27a07c-ecb1-21be-bf8f-e7365ec000f4@gmail.com> <40c81df4-d17f-c374-e5a8-c5b8edd914b5@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 8 May 2017 17:42:06 +0300
Message-ID: <CAHp75Vd8g9aczv4V+dKJoE7Lw8d2yyNQggKp6msLzcnZpQ+-_w@mail.gmail.com> (sfid-20170508_164341_194807_6E8B44F3)
Subject: Re: [PATCH v5] staging: rtl8723bs: remove re-positioned call to kfree
 in os_dep/ioctl_cfg80211.c
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>, jes.sorensen@gmail.com,
        Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 7, 2017 at 1:04 PM, Ian W MORRISON <ianwmorrison@gmail.com> wrote:
> A kernel cloned from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git and
> built with the latest RTL8723BS driver included (CONFIG_RTL8723BS=m)
> fails when booting on an Intel Atom device with the RTL8723BS wifi
> chipset due to an error in
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c.
>
> The kernel when booted with Ubuntu 17.04 results in an unusable system
> however with the following patch booting is successful and the system
> is usable. The patch and kernel builds have been tested against on an
> Intel Compute Stick (STCK1A32WFC model).
>
> This version of the patch (version 5) has tabs rather than spaces, no
> wrap around, a changelog and a sign-off email.

What are you trying to achieve by posting this patch over and over so often?

Version 5 look pretty good to me. Just stop posting it again and wait
when Greg takes it.

FWIW (version 5!):
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

-- 
With Best Regards,
Andy Shevchenko
