Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45213 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2IZMTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 08:19:30 -0400
Received: by obbuo13 with SMTP id uo13so454919obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 05:19:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5062EBCE.70700@lenbrook.com>
References: <5062E0CB.6040308@gmail.com>
	<5062EBCE.70700@lenbrook.com>
Date: Wed, 26 Sep 2012 17:49:30 +0530
Message-ID: <CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com> (sfid-20120926_141934_369021_2274EF3B)
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Jonathan Bagg <jbagg@lenbrook.com>
Cc: Ben Gray <ben.r.gray@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 26, 2012 at 5:19 PM, Jonathan Bagg <jbagg@lenbrook.com> wrote:
> I've had the same experience, I can connect with iw, but not with
> wpa_supplicant with wpa.  I also couldn't get higher than 65Mbps, MCS7
> (other devices on the same router will go faster).  I'm probably the other
> post you mentioned.

We have a fix, I shall validate it and send it upstream.

>
> Jon
>
>
> On 12-09-26 07:02 AM, Ben Gray wrote:
>>
>> Hi,
>>
>>     I have a bunch of UB134 USB dongles which have a ath6kl chip with H/W
>> version 0x31c8088a, I'm trying to get them to work with the ath6kl driver
>> from the compat-wireless-3.6-rc5-1 package. I've applied this
>> (https://patchwork.kernel.org/patch/1203191/) patch to the source and pulled
>> the hw1.3 firmware from the linux-firmware git.
>>
>>     The driver works as far as it can scan AP's and connect to unencrypted
>> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I realise
>> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant and
>> driver logs if that helps, but I've seen another post which says they
>> couldn't get WPA to work either, so I'd like to know if this is a known
>> issue with the driver and/or firmware? Has anyone had any luck getting
>> WPA/WPA2 working with ath6kl hw1.3 ?
>>
>>     If this is a known issue does anyone know when it might be fixed ?
>>
>>
>> Thanks in advance,
>> Ben.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
