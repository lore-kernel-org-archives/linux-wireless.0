Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55930 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FQUdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 16:33:10 -0400
Received: by mail-oa0-f49.google.com with SMTP id n9so4077922oag.36
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 13:33:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzCDHx7s9hz0=yDYsMeb45KANW0mW8qe=uH8QJGV-64CA@mail.gmail.com>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
	<201306172038.21642.florian@openwrt.org>
	<CACna6rzCDHx7s9hz0=yDYsMeb45KANW0mW8qe=uH8QJGV-64CA@mail.gmail.com>
Date: Mon, 17 Jun 2013 22:33:08 +0200
Message-ID: <CACna6rwK5yE0gn59FTDG9C+pSTqGc3NFXPNXKY=Wv+wgOHQq=A@mail.gmail.com> (sfid-20130617_223315_007242_B8767C9A)
Subject: Re: [PATCH] ssb: add struct for serial flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/17 Rafał Miłecki <zajec5@gmail.com>:
> 2013/6/17 Florian Fainelli <florian@openwrt.org>:
>> Hello Rafal,
>>
>> Le lundi 17 juin 2013 18:56:20, Rafał Miłecki a écrit :
>>> This data allow writing for example MTD driver.
>>
>> Your commit message could probably have some more information, by looking at
>> the patch, it is not entirely clear to me what this does, especially as sflash
>> is just a write only structure?
>
> OK, no problem. I'll give people w little more time for comments, and
> then I'll submit next version.

It's already in wireless-next, so I'll explain this just in an e-mail.
There is not much more to explain anyway ;)

-- 
Rafał
