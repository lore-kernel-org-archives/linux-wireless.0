Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:49233 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0IBENs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 00:13:48 -0400
Received: by pxi10 with SMTP id 10so14914pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Sep 2010 21:13:48 -0700 (PDT)
Message-ID: <4C7F2477.6030006@gmail.com>
Date: Wed, 01 Sep 2010 23:13:43 -0500
From: =?UTF-8?B?Q2FybG9zIFNhbHZhZG9yIFDDqXJleiBTYWxnYWRv?=
	<carlosalvatore@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless-2.6.35-rc6 won't build
References: <4C7D17CF.6030501@gmail.com> <AANLkTik8PLwUfLU1OouBq6uPwSvaWBokAkSHcCzx97ms@mail.gmail.com> <4C7D2DB6.2090609@gmail.com>
In-Reply-To: <4C7D2DB6.2090609@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2010 11:28 AM, Carlos Salvador Pérez Salgado wrote:
> On 08/31/2010 10:32 AM, Luis R. Rodriguez wrote:
>> 2010/8/31 Carlos Salvador Pérez Salgado<carlosalvatore@gmail.com>:
>>> Do you have a better idea of how can I fix that? I'll really 
>>> appreciate it.
>> Yeah, try to compat-wireless-2.6.36-rc2 ...
>>
>>    Luis
>>
> Nope... the same error...
>
>
>   LD      
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/rfkill/built-in.o
>   LD      
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/built-in.o
>   CC [M]  
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c: In 
> function ‘cfg80211_netdev_notifier_call’:
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:705: 
> error: ‘struct net_device’ has no member named ‘wireless_handlers’
> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:706: 
> error: ‘struct net_device’ has no member named ‘wireless_handlers’
> make[3]: *** 
> [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o] 
> Error 1
> make[2]: *** 
> [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless] Error 2
> make[1]: *** [_module_/media/disk/temp/compat-wireless-2.6.36-rc2-1] 
> Error 2
> make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
> make: *** [modules] Error 2
>
> That didn't help. I hope you can give me another idea.
> Thanks.
So...? What should I do?
