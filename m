Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35017 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdCCNj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:39:28 -0500
Received: by mail-oi0-f66.google.com with SMTP id x195so3398300oia.2
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 05:39:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170303103330.4914-1-zajec5@gmail.com>
References: <20170303103330.4914-1-zajec5@gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 3 Mar 2017 11:46:58 +0100
Message-ID: <CAK8P3a1EoH9WzZAqDE0eO=n7zqQUJSnrShFyVEKiA=kQb5LkJw@mail.gmail.com> (sfid-20170303_143936_590499_79B81EE9)
Subject: Re: [PATCH 4.12] bcma: drop unneeded check for CONFIG_OF_IRQ
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 3, 2017 at 11:33 AM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>=
 wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> We already have the same check in bcma_of_get_irq which really calls
> symbols available with CONFIG_OF_IRQ only. It appears this duplicated
> check was accidentally added in commit c58d900cc96a ("bcma: fix building
> without OF_IRQ"). The rest of code in bcma_of_fill_device should work
> fine without CONFIG_OF_IRQ.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

Acked-by: Arnd Bergmann <arnd@arndb.de>
