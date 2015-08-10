Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33592 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbbHJMqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 08:46:23 -0400
Received: by obbhe7 with SMTP id he7so26340607obb.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 05:46:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACRpkdYu2ve=XT2N7qWarf=BXJosiQ_6SzCsXkqrV52iQ0-SpQ@mail.gmail.com>
References: <CACRpkdYu2ve=XT2N7qWarf=BXJosiQ_6SzCsXkqrV52iQ0-SpQ@mail.gmail.com>
Date: Mon, 10 Aug 2015 14:46:22 +0200
Message-ID: <CACRpkdamJbKTRHUAQROCoucpy6zPLRN45dU8XAxQNKV=5KWkhg@mail.gmail.com> (sfid-20150810_144627_333745_5D0321AC)
Subject: Re: Driver for Mediatek MT7630E
From: Linus Walleij <linus.walleij@linaro.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 12:23 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> My daughter has this device in her laptop it seems, sigh.
>
> I might start fiddling with it unless someone else is already
> doing it.

I managed to rebase the patch to mainline HEAD and have
it compiling and booting without crashing. It also lists the
APs nicely. However connect fails with some random
encryption complaints so I will work on this whenever I have
time.

If there is general interest to hack on this I can publish my
kernel tree @kernel.org.

Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> The driver for MediaTek MT7601U was recently added to upstream at:
> drivers/net/wireless/mediatek/mt7601u/

Awesome, I can see I have some duplicated defines etc
from this in my patch, so will see if they can integrate
cleanly if I even get this working properly.

Yours,
Linus Walleij
