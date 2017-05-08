Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36763 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754614AbdEHPGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 11:06:17 -0400
MIME-Version: 1.0
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Tue, 9 May 2017 01:06:16 +1000
Message-ID: <CAFXWsS9N2_BbmNZ38w3FGRa0yJ3zNqxWemXZq6drLU+LzfaB4A@mail.gmail.com> (sfid-20170508_170641_456387_4A8EC978)
Subject: Re: [PATCH v5] staging: rtl8723bs: remove re-positioned call to kfree
 in os_dep/ioctl_cfg80211.c
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 May 2017 at 00:42, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> On Sun, May 7, 2017 at 1:04 PM, Ian W MORRISON <ianwmorrison@gmail.com> wrote:

<snip>

>
> What are you trying to achieve by posting this patch over and over so often?
>
> Version 5 look pretty good to me. Just stop posting it again and wait
> when Greg takes it.
>

I made a series of errors in the patch submission due to inexperience
in submitting my very first patch. The visibility of my minor mistakes
in certainly not what I would have liked and I can only apologize for
the annoyance caused. I believe I have finally corrected the patch to
meet the exacting standards required and having learnt from the
experience I hope never to repeat them.

> FWIW (version 5!):
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>
> --
> With Best Regards,
> Andy Shevchenko

Thank you for your review,
Ian
