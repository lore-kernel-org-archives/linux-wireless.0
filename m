Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49012 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0GZBOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jul 2010 21:14:50 -0400
Received: by gyg10 with SMTP id 10so670466gyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jul 2010 18:14:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinZG-kHrS-s_94Bq4JNXuyf6kWzqsVRAVjdGQ3c@mail.gmail.com>
References: <87vd88n1i8.fsf@gmail.com>
	<4C474851.4000809@lwfinger.net>
	<AANLkTinZG-kHrS-s_94Bq4JNXuyf6kWzqsVRAVjdGQ3c@mail.gmail.com>
Date: Mon, 26 Jul 2010 09:14:48 +0800
Message-ID: <AANLkTinVBYj5tjz9EzxYPoz6A9s8sTJLN3hN3MB=kACY@mail.gmail.com>
Subject: Re: Master mode in rtl8187
From: August <august.seu@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've followed the driver of the rtl818x in 26.34 and draw some
pictures of source.However, some additional work interrupted me.
The address is http://augustseu-blog.appspot.com/2010/06/6/Wlan.html
If it was any helpful,



2010/7/25 Hin-Tak Leung <hintak.leung@gmail.com>:
> On 7/21/10, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 07/21/2010 01:17 PM, Ben Gamari wrote:
>>> Hey all,
>>>
>>> I recently purchased a Netgear WG111v2 (based on rtl8187b) and after
>>> seeing scattered reports[1] that master mode may be supported by the
>>> rtl8187 driver. Unfortunately, hostapd throws up when it attempts to put
>>> the card into master mode. Is master mode supported by this driver? I've
>>> tried both 2.6.34 as well as the latest wireless-testing tree and
>>> neither seem to work.
>>
>> My WG111V2 has an RTL8187L chip in it, not an RTL8187B. No, master mode is
>> NOT
>> supported by this driver. Adding that feature has been on my list of things
>> to
>> do, but the priority is very low. I really have little desire to convert my
>> $600
>> laptop into a $40 access point.
>>
>>> I noticed there was a patch[2] sent out a few years back, but it seems
>>> no one followed up. While I don't have much experience working with
>>> wireless hardware I've done kernel driver work before, so with some
>>> guidance I might be able to finish up that patch. Any input would be
>>> greatly appreciated. Thanks!
>>
>>> [1]
>>> http://osdir.com/ml/linux.kernel.wireless.general/2007-07/msg00289.html
>>> [2]
>>> http://osdir.com/ml/linux.kernel.wireless.general/2007-06/msg00455.html
>>
>> That patch is useless. The rtl8187 driver and mac80211 have changed so much
>> that
>> it cannot be made to apply, and would not be likely to work.
>>
>> One other thing to consider. The RTL8187L has only a single transmit queue.
>> Will
>> the device be able to transmit beacons with an appropriate timing accuracy?
>>
>> To modify the driver, you will need to study some other driver that does
>> work in
>> master mode.
>
> There were some discussion a while back that some generic master mode
> support for all mac80211-based drivers might eventually happen.  Is
> that still the case?
>
> Hin-Tak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
---------------------------------
Best Regards
张杰
ADD：苏州 工业园区 文景路 东南大学苏州研究院
