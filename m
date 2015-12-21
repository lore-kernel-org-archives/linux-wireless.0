Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35850 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbLUSjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 13:39:49 -0500
Received: by mail-lf0-f54.google.com with SMTP id z124so111323630lfa.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 10:39:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJL_dMuDXMQYRpDAk9FOnTeA+4vsQARw8028DRrmKeRNeLQzug@mail.gmail.com>
References: <CAJL_dMuDXMQYRpDAk9FOnTeA+4vsQARw8028DRrmKeRNeLQzug@mail.gmail.com>
Date: Mon, 21 Dec 2015 20:39:47 +0200
Message-ID: <CAJL_dMuszBL9DsbEyy1kMyRSBxQMTz1cQDhA0yCW6660a5EkYA@mail.gmail.com> (sfid-20151221_193952_115274_11B70541)
Subject: Re: Mediatek wifi
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, 's/usb/pci'

On Mon, Dec 21, 2015 at 2:09 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi Linus Walleij, and everyone interested.
>
> http://askubuntu.com/questions/676390/no-wi-fi-on-ubuntu-14-04-lts-asus-notebook-with-mediatek-mt7630e
>
> Here is the bug report:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146
>
> https://github.com/neurobin/MT7630E is reported to work for wifi.
>
> Maybe it works to add usb ids to
> https://github.com/torvalds/linux/tree/master/drivers/net/wireless/rt2x00
> and firmware.
