Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35104 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730317AbeGVXvz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 19:51:55 -0400
Received: by mail-it0-f42.google.com with SMTP id q20-v6so21230623ith.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2018 15:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <CACRpkdbdt5Jxa+=4kBGEjRdiVwv9Py3Lo5ngxB-sZO-Xgzb09g@mail.gmail.com>
In-Reply-To: <CACRpkdbdt5Jxa+=4kBGEjRdiVwv9Py3Lo5ngxB-sZO-Xgzb09g@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 23 Jul 2018 00:53:24 +0200
Message-ID: <CACRpkdZfxjuYjJX-qMnVOWpwjBJ-MVgP==RJOOiH=3D4gdFQEg@mail.gmail.com> (sfid-20180723_005339_945787_9A03060A)
Subject: Re: RT2880F based iNIC mini-PCI network card
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 15, 2018 at 1:37 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> I'm curious to hear if you have hints of this beast:
>
> lspci:
> 00:0c.0 Class 0200: 1814:0801
(...)
> Has someone seen a vendor tree where this leaked out by
> mistake or so?

The Internet is so big. impossible to keep secrets there.
So I found it:
https://github.com/kovz/ralink_inic

Now I just need to churn through this.

The firmware is ~500K. I guess an entire operating system.

Oh well, I guess we can replace it with RT2880F Linux since
it is just a vanilla SoC.

Yours,
Linus Walleij
