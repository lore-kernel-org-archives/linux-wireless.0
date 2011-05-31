Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:32875 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1EaTYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:24:54 -0400
Message-ID: <20110531222451.620004sd89q8uzr7@www.81.fi> (sfid-20110531_212457_474246_1B20183C)
Date: Tue, 31 May 2011 22:24:51 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
References: <176718.65400.qm@web161618.mail.bf1.yahoo.com>
In-Reply-To: <176718.65400.qm@web161618.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Walter Goldens <goldenstranger@yahoo.com>:

>
>> >> Date: Sunday, May 29, 2011, 11:04 PM
>> >> zd_chip.h contains one function with
>> >> a pointer to ieee80211_hw but doesn't
>> >> include mac80211.h. As a temporary solution
>> include
>> >> mac80211.h to avoid
>> >> a warning.
>> >
>> > I'm still getting a warning with this patch. I think
>> this happened when Jussi fixed some stuff awhile back.
>> >
>> > In function ‘zd_mac_alloc_hw’:
>> > drivers/net/wireless/zd1211rw/zd_mac.c:1340:7:
>> warning: statement with no effect
>>
>> Hm.. I'm not getting this with wireless-testing.
>>
>
> Ubuntu's default kernels 2.6.35 and .38 exhibit this warning when  
> compiling compat-wireless. If my memory serves me right, the warning  
> began to occur right after you've submitted a patch to rename CR*  
> marcos to ZD_CR*.

Compiled compat-wireless-2011-05-30 on Ubuntu 11.04, 64bit:  
2.6.38-8-generic & 2.6.38-8-server and 32bit: 2.6.38-8-generic &  
2.6.38-8-generic-pae. No warnings at zd1211rw at all. (?)

>
> Walter
>
>


