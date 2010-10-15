Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50107 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0JOLBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 07:01:38 -0400
Received: by ewy20 with SMTP id 20so643449ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 04:01:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=YPcjudD5u0oLOmCj_PQqSKWCdPab45uLCiD76@mail.gmail.com>
References: <1287090064-14607-1-git-send-email-zajec5@gmail.com>
	<1287090064-14607-2-git-send-email-zajec5@gmail.com>
	<AANLkTi=YPcjudD5u0oLOmCj_PQqSKWCdPab45uLCiD76@mail.gmail.com>
Date: Fri, 15 Oct 2010 13:01:36 +0200
Message-ID: <AANLkTinaeO-6M9DbvW2ZHJHyrBhRK+Gdu+4++0jFLqQA@mail.gmail.com>
Subject: Re: [PATCH 2/3] b43: N-PHY: define registers names for 2056 radio
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 października 2010 23:23 użytkownik Luis R. Rodriguez
<mcgrof@gmail.com> napisał:
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
>
> You forgot to include their full license here.

As discussed in another topic, I didn't add any copyrightable data
here. "Just numbers". I added info about source of defines as some
kind of over-kindness ;)

-- 
Rafał
