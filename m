Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50415 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0AYXR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 18:17:56 -0500
Received: by ewy19 with SMTP id 19so341558ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 15:17:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100125221935.GC14699@tuxdriver.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
	 <b170af451001251035t23f3978cga52258722ea29770@mail.gmail.com>
	 <b170af451001251036m8b33f3er9f0a363a03ea21cb@mail.gmail.com>
	 <201001251953.21692.mb@bu3sch.de>
	 <20100125221935.GC14699@tuxdriver.com>
Date: Tue, 26 Jan 2010 00:17:54 +0100
Message-ID: <b170af451001251517u19130393kdd2bca4765dbc604@mail.gmail.com>
Subject: Re: [PATCH 2/4] b43: make cordic common (LP-PHY and N-PHY need it)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/25 John W. Linville <linville@tuxdriver.com>:
> On Mon, Jan 25, 2010 at 07:53:19PM +0100, Michael Buesch wrote:
>> On Monday 25 January 2010 19:36:27 Rafał Miłecki wrote:
>> > W dniu 25 stycznia 2010 19:35 użytkownik Rafał Miłecki
>> > <zajec5@gmail.com> napisał:
>> > > 2010/1/25 Michael Buesch <mb@bu3sch.de>:
>> > >> On Monday 25 January 2010 18:59:59 Rafał Miłecki wrote:
>> > >>> +/* Complex number using 2 32-bit signed integers */
>> > >>> +typedef struct { s32 i, q; } b43_c32;
>> > >>
>> > >> No typedef. ever.
>> > >
>> > > Well, I just copied (Gabor's?) code here. But of course I can fix this
>> > > by the way, no problem :)
>>
>> Yeah, I saw that. We can fix it while we're at it. ;)
>>
>> > > Just read about typedef in Linux Kernel Coding Style, didn't know
>> > > about this earlier. Thanks for pointing.
>> >
>> > Is this OK to fix this in separated patch? Or should I modify this set
>> > of patches?
>>
>> Well, as you touch any reference to the typedef anyway (you renamed it),
>> you can just put the keyword "struct" in front of the references and no separate patch is needed.
>> It won't even grow your current patch in the number of changed lines.
>
> I took care of these modifications to the original patch...

Hey, thank you! :)

-- 
Rafał
