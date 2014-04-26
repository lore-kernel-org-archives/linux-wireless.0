Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51829 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaDZR3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2014 13:29:03 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so3990332wiv.16
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2014 10:29:01 -0700 (PDT)
Message-ID: <535BECD9.1070103@gmail.com> (sfid-20140426_192908_360638_02F0A277)
Date: Sat, 26 Apr 2014 20:28:57 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Julian Sikorski <belegdol@gmail.com>, unlisted-recipients:;
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
References: <5358AADD.3010702@gmail.com>	<ljbdr0$c27$1@ger.gmane.org>	<535A12F3.8020003@gmail.com> <CACna6rx+3CeucmhDDFwTii8A4KiEsTDQSeyTH6aLaYfs0YkaBg@mail.gmail.com> <535A3021.8070003@gmail.com> <535AE15D.8010704@gmail.com>
In-Reply-To: <535AE15D.8010704@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/26/2014 01:27 AM, Julian Sikorski wrote:
> W dniu 25.04.2014 11:51, Emmanuel Grumbach pisze:
>>
>>
>> On 04/25/2014 12:15 PM, Rafał Miłecki wrote:
>>> 2014-04-25 9:46 GMT+02:00 Emmanuel Grumbach <egrumbach@gmail.com>:
>>>> On 04/24/2014 07:24 PM, Julian Sikorski wrote:
>>>>> Is such a major performance hit expected from this change? Here is the
>>>>> commit in question:
>>>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182
>>>>>
>>>>
>>>> Right - I disabled TX APMDU in this patch. This feature gives a big boost in TX performance, but lots of people experienced bugs that disappeared when this feature was disabled. This bug is in the firmware. Since the most common use case is to browse the internet which is more Rx than Tx, I decided to disabled this feature by default and allow people to enabled it using the module parameter.
>>>
>>> Any plans to update (fix) the firmware?
>>>
>>
>> I don't work on the firmware level, so I can't really say, but I doubt someone will have the cycles to fix the firmware for these devices. Newer devices (7260 and up) have this feature enabled.
>>
> Can this feature be disabled on a per-device basis? It clearly works for
> 6230 and is a huge performance hit when gone.
> 

It works for you - but for others it didn't.
