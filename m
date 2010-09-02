Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0IBHRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 03:17:47 -0400
Received: by iwn5 with SMTP id 5so233931iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 00:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C7F2477.6030006@gmail.com>
References: <4C7D17CF.6030501@gmail.com> <AANLkTik8PLwUfLU1OouBq6uPwSvaWBokAkSHcCzx97ms@mail.gmail.com>
 <4C7D2DB6.2090609@gmail.com> <4C7F2477.6030006@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Sep 2010 00:17:27 -0700
Message-ID: <AANLkTinDXfNBBBjJYtu12vbARecc1xgYO=bA_K+Wu-h2@mail.gmail.com>
Subject: Re: compat-wireless-2.6.35-rc6 won't build
To: =?UTF-8?Q?Carlos_Salvador_P=C3=A9rez_Salgado?=
	<carlosalvatore@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/1 Carlos Salvador Pérez Salgado <carlosalvatore@gmail.com>:
> On 08/31/2010 11:28 AM, Carlos Salvador Pérez Salgado wrote:
>>
>> On 08/31/2010 10:32 AM, Luis R. Rodriguez wrote:
>>>
>>> 2010/8/31 Carlos Salvador Pérez Salgado<carlosalvatore@gmail.com>:
>>>>
>>>> Do you have a better idea of how can I fix that? I'll really appreciate
>>>> it.
>>>
>>> Yeah, try to compat-wireless-2.6.36-rc2 ...
>>>
>>>   Luis
>>>
>> Nope... the same error...
>>
>>
>>  LD
>>  /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/rfkill/built-in.o
>>  LD
>>  /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/built-in.o
>>  CC [M]  /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o
>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c: In
>> function ‘cfg80211_netdev_notifier_call’:
>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:705:
>> error: ‘struct net_device’ has no member named ‘wireless_handlers’
>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:706:
>> error: ‘struct net_device’ has no member named ‘wireless_handlers’
>> make[3]: ***
>> [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o] Error 1
>> make[2]: *** [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless]
>> Error 2
>> make[1]: *** [_module_/media/disk/temp/compat-wireless-2.6.36-rc2-1] Error
>> 2
>> make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
>> make: *** [modules] Error 2
>>
>> That didn't help. I hope you can give me another idea.
>> Thanks.
>
> So...? What should I do?

Sorry, I have not have had time to test compile against 2.6.35, but
when I do I will let you know.

  Luis
