Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39095 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0AYSfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:35:30 -0500
Received: by ewy19 with SMTP id 19so49054ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:35:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001251932.14633.mb@bu3sch.de>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
	 <1264442401-6364-3-git-send-email-zajec5@gmail.com>
	 <201001251932.14633.mb@bu3sch.de>
Date: Mon, 25 Jan 2010 19:35:28 +0100
Message-ID: <b170af451001251035t23f3978cga52258722ea29770@mail.gmail.com>
Subject: Re: [PATCH 2/4] b43: make cordic common (LP-PHY and N-PHY need it)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/25 Michael Buesch <mb@bu3sch.de>:
> On Monday 25 January 2010 18:59:59 Rafał Miłecki wrote:
>> +/* Complex number using 2 32-bit signed integers */
>> +typedef struct { s32 i, q; } b43_c32;
>
> No typedef. ever.

Well, I just copied (Gabor's?) code here. But of course I can fix this
by the way, no problem :)

Just read about typedef in Linux Kernel Coding Style, didn't know
about this earlier. Thanks for pointing.

-- 
Rafał
