Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47166 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0ABRpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:45:21 -0500
Received: by ewy19 with SMTP id 19so6013311ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 09:45:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001021843.57583.mb@bu3sch.de>
References: <op.u5wyyryj9lhzdc@linux-g0th.site>
	 <201001021843.57583.mb@bu3sch.de>
Date: Sat, 2 Jan 2010 18:45:19 +0100
Message-ID: <b170af451001020945n561ac718p78517a5fb7576f87@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: clean table init, check PHY rev (V2)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2010 18:43 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> On Saturday 02 January 2010 17:33:53 Rafał Miłecki wrote:
>> --- a/drivers/net/wireless/b43/tables_nphy.h
>> +++ b/drivers/net/wireless/b43/tables_nphy.h
>
>> -extern const u8 b43_ntab_adjustpower0[];
>> +static const u8 b43_ntab_adjustpower0[];
>
> Are you serious? o.O
> Come on... You can do better ;)

Yeah, I guess so :)

-- 
Rafał
