Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55521 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2IZPLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 11:11:05 -0400
Received: by wibhr7 with SMTP id hr7so927867wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 08:11:04 -0700 (PDT)
Message-ID: <50631B06.4030104@gmail.com> (sfid-20120926_171113_146090_E82D7163)
Date: Wed, 26 Sep 2012 16:11:02 +0100
From: Ben Gray <ben.r.gray@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Jonathan Bagg <jbagg@lenbrook.com>, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
References: <5062E0CB.6040308@gmail.com> <5062EBCE.70700@lenbrook.com> <CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com> <5062F6A6.8000207@gmail.com> <CAD2nsn3u09ywKek2DT+R__eezq68tTzC43OuQCZCGf3_QKa8cg@mail.gmail.com>
In-Reply-To: <CAD2nsn3u09ywKek2DT+R__eezq68tTzC43OuQCZCGf3_QKa8cg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Wed, Sep 26, 2012 at 6:05 PM, Ben Gray <ben.r.gray@gmail.com> wrote:
>> Wow that was quick, thanks very much.  Any idea when it will make it
>> upstream ?
>
> can you please try the attached patch. I will just put tested-by if it
> works for you too.
> It works for me.
Yes, that works for me :), I've tried both WPA and WPA2 and both work so 
far.

Many thanks Mohammed, it's much appreciated.
>
>>
>> I've attached the wpa_supplicant (v0.7.3) log in case anyone is still
>> interested.
>>
>> Thanks everyone for your replies,
>>
>> Ben.
>>
>>
>>
>> On 26/09/2012 13:19, Mohammed Shafi wrote:
>>>
>>> On Wed, Sep 26, 2012 at 5:19 PM, Jonathan Bagg <jbagg@lenbrook.com> wrote:
>>>>
>>>> I've had the same experience, I can connect with iw, but not with
>>>> wpa_supplicant with wpa.  I also couldn't get higher than 65Mbps, MCS7
>>>> (other devices on the same router will go faster).  I'm probably the
>>>> other
>>>> post you mentioned.
>>>
>>>
>>> We have a fix, I shall validate it and send it upstream.
>>>>
>>>>
>>>> Jon
>>>>
>>>>
>>>> On 12-09-26 07:02 AM, Ben Gray wrote:
>>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>>       I have a bunch of UB134 USB dongles which have a ath6kl chip with
>>>>> H/W
>>>>> version 0x31c8088a, I'm trying to get them to work with the ath6kl
>>>>> driver
>>>>> from the compat-wireless-3.6-rc5-1 package. I've applied this
>>>>> (https://patchwork.kernel.org/patch/1203191/) patch to the source and
>>>>> pulled
>>>>> the hw1.3 firmware from the linux-firmware git.
>>>>>
>>>>>       The driver works as far as it can scan AP's and connect to
>>>>> unencrypted
>>>>> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I
>>>>> realise
>>>>> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant and
>>>>> driver logs if that helps, but I've seen another post which says they
>>>>> couldn't get WPA to work either, so I'd like to know if this is a known
>>>>> issue with the driver and/or firmware? Has anyone had any luck getting
>>>>> WPA/WPA2 working with ath6kl hw1.3 ?
>>>>>
>>>>>       If this is a known issue does anyone know when it might be fixed ?
>>>>>
>>>>>
>>>>> Thanks in advance,
>>>>> Ben.
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-wireless"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>
>
>
>

