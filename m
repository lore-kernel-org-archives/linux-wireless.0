Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61816 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3FQTqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 15:46:09 -0400
Received: by mail-oa0-f46.google.com with SMTP id h1so3957963oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 12:46:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306172038.21642.florian@openwrt.org>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
	<201306172038.21642.florian@openwrt.org>
Date: Mon, 17 Jun 2013 21:46:08 +0200
Message-ID: <CACna6rzCDHx7s9hz0=yDYsMeb45KANW0mW8qe=uH8QJGV-64CA@mail.gmail.com> (sfid-20130617_214613_338120_0D6A2B33)
Subject: Re: [PATCH] ssb: add struct for serial flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/17 Florian Fainelli <florian@openwrt.org>:
> Hello Rafal,
>
> Le lundi 17 juin 2013 18:56:20, Rafał Miłecki a écrit :
>> This data allow writing for example MTD driver.
>
> Your commit message could probably have some more information, by looking at
> the patch, it is not entirely clear to me what this does, especially as sflash
> is just a write only structure?

OK, no problem. I'll give people w little more time for comments, and
then I'll submit next version.

-- 
Rafał
