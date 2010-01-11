Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:51152 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0AKWnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:43:03 -0500
Received: by ewy1 with SMTP id 1so3831241ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 14:43:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001112342.08099.mb@bu3sch.de>
References: <op.u6b70wtk9lhzdc@linux-g0th.site>
	 <201001112313.26197.mb@bu3sch.de>
	 <b170af451001111427u25861f2bla4062a7b0aea19ec@mail.gmail.com>
	 <201001112342.08099.mb@bu3sch.de>
Date: Mon, 11 Jan 2010 23:43:00 +0100
Message-ID: <b170af451001111443g2c504ea4v63e54d9ad6e0b418@mail.gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 stycznia 2010 23:42 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> On Monday 11 January 2010 23:27:18 Rafał Miłecki wrote:
>> Whoops, I should have explained what I mean. I am not sure what CFLAGS
>> "make" picks for compiled but I get:
>>
>>   CC [M]  drivers/net/wireless/b43/phy_n.o
>> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_rev2_rssi_cal’:
>> drivers/net/wireless/b43/phy_n.c:887: warning: missing braces around initializer
>> drivers/net/wireless/b43/phy_n.c:887: warning: (near initialization
>> for ‘results[0]’)
>>
>> for s32 results[4][4] = { 0, };
>>
>
> But does this work?
> s32 results[4][4] = { };

Yes, this compiles fine, and I believe it works fine :)

-- 
Rafał
