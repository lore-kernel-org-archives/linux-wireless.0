Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35311 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3FQUke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 16:40:34 -0400
Received: by mail-oa0-f46.google.com with SMTP id h1so4051626oag.33
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 13:40:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzDv1d4Znni+XUXprZp4RrFLr5yyBdJyPVLHB9n2U3_BQ@mail.gmail.com>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
	<CACna6rzDv1d4Znni+XUXprZp4RrFLr5yyBdJyPVLHB9n2U3_BQ@mail.gmail.com>
Date: Mon, 17 Jun 2013 22:40:33 +0200
Message-ID: <CACna6ryujzGPhtQ=aAeMegWE_MrZEGQWk+Ok3+Ww+PriDoZovg@mail.gmail.com> (sfid-20130617_224038_466832_4796118C)
Subject: Re: [PATCH] ssb: add struct for serial flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/17 Rafał Miłecki <zajec5@gmail.com>:
> 2013/6/17 Rafał Miłecki <zajec5@gmail.com>:
>> This data allow writing for example MTD driver.
>
> To make this a bit more clear:
>
> Up until now, we were detecting flash model in
> driver_chipcommon_sflash.c, but nothing more than that. It was printed
> and that's all. Noone could read it's details or/and use it.
>
> As providing an access to the flash is usually a good idea, we need an
> additional MTD driver for it. Such MTD driver needs some basic info
> about flash. It's mapping address and size at least.

As an example you can see drivers/mtd/devices/bcm47xxsflash.c which a
driver for "bcma_sflash" platform device.

-- 
Rafał
