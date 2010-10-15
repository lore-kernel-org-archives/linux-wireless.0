Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42164 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0JOLCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 07:02:12 -0400
Received: by ewy20 with SMTP id 20so643917ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 04:02:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimesczkO4iSrjPjAGMf+xs04bKGALumAFq7GzTQ@mail.gmail.com>
References: <1287090064-14607-1-git-send-email-zajec5@gmail.com>
	<1287090064-14607-2-git-send-email-zajec5@gmail.com>
	<AANLkTimesczkO4iSrjPjAGMf+xs04bKGALumAFq7GzTQ@mail.gmail.com>
Date: Fri, 15 Oct 2010 13:02:11 +0200
Message-ID: <AANLkTik0FZQOyePhY1KDAVFiD5YQ9bF4M5A5p8SGUYAy@mail.gmail.com>
Subject: Re: [PATCH 2/3] b43: N-PHY: define registers names for 2056 radio
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 października 2010 01:58 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/10/14 Rafał Miłecki <zajec5@gmail.com>:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Cc: Henry Ptasinski <henryp@broadcom.com>
>> Cc: Brett Rudley <brudley@broadcom.com>
>> Cc: Nohee Ko <noheek@broadcom.com>
>> ---
>>  drivers/net/wireless/b43/radio_2056.h |  522 +++++++++++++++++++++++++++++++++
>>  1 files changed, 522 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
>> index 60341d7..462c9fd 100644
>> --- a/drivers/net/wireless/b43/radio_2056.h
>> +++ b/drivers/net/wireless/b43/radio_2056.h
>> @@ -4,6 +4,9 @@
>>
>>   Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
>>
>> +  Some parts of the code in this file are derived from the brcm80211
>> +  driver  Copyright (c) 2010 Broadcom Corporation
>> +
>>   This program is free software; you can redistribute it and/or modify
>>   it under the terms of the GNU General Public License as published by
>>   the Free Software Foundation; either version 2 of the License, or
>> @@ -28,6 +31,525 @@
>>
>>  #include "tables_nphy.h"
>>
>> +#define RADIO_2056_SYN                         (0x0 << 12)
>> +#define RADIO_2056_TX0                         (0x2 << 12)
>> +#define RADIO_2056_TX1                         (0x3 << 12)
>
> Please use B2056_ as the prefix. See LP-PHY.

What does it mean? This "B" prefix?

-- 
Rafał
