Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:54895 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0DJTky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 15:40:54 -0400
Received: by qyk9 with SMTP id 9so2558540qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 12:40:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
	 <4BB7660A.3030900@lwfinger.net>
	 <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
	 <4BB773A9.2070703@lwfinger.net>
	 <n2n917a57cb1004031000h9910230ew50c6380788a64b1c@mail.gmail.com>
	 <q2k917a57cb1004100507s17249540xfb11a2e2f0a2dd76@mail.gmail.com>
	 <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com>
Date: Sat, 10 Apr 2010 16:40:53 -0300
Message-ID: <y2g917a57cb1004101240g8033e225n57bf68b6d37b5431@mail.gmail.com>
Subject: Re: RTL 8187b - naughty behaviour
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/10 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sat, Apr 10, 2010 at 2:07 PM, Rogerio Luz Coelho
> <rogluz.news@gmail.com> wrote:
>> 2010/4/3 Rogerio Luz Coelho <rogluz.news@gmail.com>:
>>> 2010/4/3 Larry Finger <Larry.Finger@lwfinger.net>:
>>>> On 04/03/2010 11:49 AM, Rogerio Luz Coelho wrote:
>>>>>
>>>>> I have a MS-Win7 instalation on this Laptop and it works 100% even at
>>>>> longer distances than you report,even with walls in between.
>>>>>
>>>>> Will do the tcpperf test as soon as I get home. There are other with
>>>>> the same problem with my exact chip here in Brasil , that is because
>>>>> one of our leading Laptop vendors uses this config.
>>>>
>>>> What is the exact make and model of the device? It might be difficult
>>>> for me to get one in the US, but one of the rtl8187 developers lives in
>>>> Brazil. He should be able to find one.
>>>>
>>>
>>> It愀 a POSITIVO R430L - Core 2 Duo 4GB RAM
>>>
>>>
>>>>> Does it matter that the USB port used in this setting is a connected
>>>>> to a USB HUB and then to the mother board?
>>>>
>>>> Is the hub passive, or is it powered? If the hub is good and not
>>>> underpowered, it should be OK.
>>>>
>>>>> More details and tests will come your way in a day or two ... will
>>>>> reinstall Mandriva 2010 and do some tests with older kernels.
>>>>
>>>> If you can download an openSUSE 11.2 Live CD and burn it, you would not
>>>> even have to do an installation. That one has a 2.6.31 kernel.
>>>>
>>>> Larry
>>
>>
>> Downloaded and installed:
>>
>> OpenSuse 11.2 - LiveCD  result: Gnome Network-Manager tells me there
>> is connection but no ping resposes, Firefox complains about conections
>> errors.
>>
>> Mandriva 2010.0 (kernel 2.6.31-12) result: concection comes and goes
>> ... generally the first boot of the day connects, but it lasts less
>> than 5min. The error code is the "deauthentication by local reason
>> (reason=3) again.
>>
>> MS-Win7 : connects and is as fast as ever.
>>
>> -- Any other suggestions?
>>
>> Rogerio
>>
>> PS: Will give OpenSuse a HD install atempt and will try to debug the
>> Mandriva for some time, future tries involve Debian Stable (old
>> kernel) and some Fedora (any suggestions?) and the NDISwrapper drive
>> in a Debian Testing (the Distro I need working)
>
> Hi,
>
> Please also test Realtek's official r8187b driver. If possible, please
> do an mmiotrace on that driver.

Ok ... The official Realtek is only for 32bits systems right ? ( At
least the guys at Realtek support told me so... ) and this mmiotrace
can be accomplished how? Is it a program, a command, a debug message
in some form? Sorry, as I said earlier I am NOT a kernel programer.

Rogerio
