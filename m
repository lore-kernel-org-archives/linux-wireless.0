Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34821 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1HYCy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 22:54:58 -0400
Received: by vws1 with SMTP id 1so1605913vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 19:54:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGwCZhrYA2e_dVf6uHDaTfC35m2wopdLCOit8UFDa8D9v_v3Tw@mail.gmail.com>
References: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com>
	<4E54C87A.4080407@broadcom.com>
	<CAGwCZhrYA2e_dVf6uHDaTfC35m2wopdLCOit8UFDa8D9v_v3Tw@mail.gmail.com>
Date: Thu, 25 Aug 2011 10:54:58 +0800
Message-ID: <CAGwCZhpjN5E4Spp4Qo1wfiMzx2Wxm5_pfzHxY8w+89yjqbckAA@mail.gmail.com> (sfid-20110825_045503_159368_2B685330)
Subject: Re: force wifi radio to sleep immediately
From: Hao Han <hhanwm@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is any way to force wifi to maintain at low power (sleep mode)
immediately? Turing on/off radio is too long for my project. Thanks!

Best,
Hao

On Wed, Aug 24, 2011 at 6:12 PM, Hao Han <hhanwm@gmail.com> wrote:
> Thank you for your quick reply, Gr. AvS.
>
> According to my understanding, in power save mode (PSM), the station
> will go to sleep immediately (i.e. maintaining a very low power) after
> sending packet with pwr mgt bit in 802.11 mac header setting to 1.
>
> My question is if we can force the station to go to such a low power
> level by calling some function.
>
> It seems to me that it costs extra time to disable/enable the radio,
> right? I hope to do it very quickly.
>
> I appreicate your help!
>
> Best,
> Hao
>
>
> On Wed, Aug 24, 2011 at 5:46 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 08/24/2011 10:43 AM, Hao Han wrote:
>>>
>>> Dear All,
>>>
>>> I am currently working on a research project based on BCM4329 driver
>>> on Nexus One. In the project, I am trying to control wifi radio to sleep
>>> and wake up manually (i.e without setting PM_OFF, PM_FAST, or PM_MAX
>>> mode). I
>>> have digged into the source code for a while, but till now I have no
>>> idea how to do that. If possible, could anyone please tell me if there is
>>> any function I can call to force wifi radio to sleep or wake up
>>> immediately.
>>>
>>> Any hint is appreciated. Thank you!
>>>
>>> Best,
>>> Hao
>>> --
>>
>> Hi Hao,
>>
>> Could please elaborate on what 'wifi radio' means in your description. It
>> makes me think about RFKILL, but that may not be the thing you are looking
>> for. With it you can disable/enable the radio within the wireless chipset.
>> The terms sleep and wakeup feel a little odd when talking about radios.
>>
>> Gr. AvS
>>
>> --
>> Almost nobody dances sober, unless they happen to be insane.
>> -- H.P. Lovecraft --
>>
>>
>>
>
