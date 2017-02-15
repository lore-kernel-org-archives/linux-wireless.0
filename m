Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37176 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdBOOmR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:42:17 -0500
Received: by mail-wm0-f45.google.com with SMTP id v77so41998572wmv.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 06:42:16 -0800 (PST)
Subject: Re: wireless driver crashing frequently
To: ravin goyal <ravirocks1021@gmail.com>
References: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
 <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com>
 <CANU0Mn2Fp=3tYb70qD7J_duA0f1wbRNr_Q3e5iv3pBTHtWM4zg@mail.gmail.com>
 <586c8cf6-75fb-64cb-adaa-4c5de7ec7008@broadcom.com>
 <CANU0Mn01mQoWfxvWK_jLRyM9MZwDR7Baeah6ZkJ6pNhxB=YeKQ@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c40fae6a-dfc6-a0ca-8ad0-3784d8a4e355@broadcom.com> (sfid-20170215_154222_294877_9B8872C3)
Date: Wed, 15 Feb 2017 15:42:15 +0100
MIME-Version: 1.0
In-Reply-To: <CANU0Mn01mQoWfxvWK_jLRyM9MZwDR7Baeah6ZkJ6pNhxB=YeKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 15-2-2017 11:55, ravin goyal wrote:
> okay thanks for the help.

No intent to blow you off. I just do not support that driver nor anyone
else on this list.

Regards,
Arend

> regards
> ravin
> 
> On 15 February 2017 at 16:20, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>>
>> On 15-2-2017 11:38, ravin goyal wrote:
>>> that is what I have found on my banana pi board running raspbian lite
>>> 3.4.112-sun8i.
>>> removing bcmdhd results in removing my wlan0 interface from the
>>> list(iwconfig/ifconfig/ip).
>>
>> Ok. If it is raspbian that choose to include bcmdhd in their distro I
>> would suggest to file the bug there [1].
>>
>> Regards,
>> Arend
>>
>> [1] https://www.raspbian.org/RaspbianBugs
