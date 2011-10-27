Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65306 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1J0NST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 09:18:19 -0400
Received: by vws1 with SMTP id 1so2389853vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 06:18:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA89B8D.7060104@lwfinger.net>
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
 <4EA89B8D.7060104@lwfinger.net>
From: Roman Proud <setamagiga@gmail.com>
Date: Thu, 27 Oct 2011 15:17:59 +0200
Message-ID: <CAF7qGM7hfaz0SGiZVZ62r_nPO8viMT5F2_Kd1uRxN9Ha3mRO+Q@mail.gmail.com> (sfid-20111027_151822_982994_ED509F9C)
Subject: Re: RTL8188RU no injection?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi peops

thx for all youre responses!

Well i didnt really thought about g and n -.-

Im using the latest 8192cu driver from Realtek now, it works just
fine. Also monitor mode works like a charm (yes if i use airmon-ng for
it). My Kernel is (now the default) Arch kernel, on Linux Version
3.0.4

My last problem is the Package injection. Im surprised you are
thinking it could work (ive found many resources that say something
different, but hey its an OpenSource driver ;)

Pls excuse my "stupidness" but im really not sure if i am using
"mac80211", i think so, its leaded in the System.

And yes its Aircrack im trying to work with, and its Aircrack which
tells me i cant use Packet Injection.
I will try Packetspammer as soon as i am at home. If this works i have
to contact Aircrack, am i right?

Greetings
Roman

2011/10/27 Larry Finger <Larry.Finger@lwfinger.net>:
> On 10/26/2011 05:29 PM, Roman Proud wrote:
>>
>> Hi there,
>>
>> i hope you guys can help me.
>> I wanted a new Wifi card, because mine has no injection, what i need
>> sometimes.
>>
>> So i forced the Internet to find that a 8187 would be best for. So i
>> bought the 8188 (newer = better?)... i never had thought about so much
>> difference in just one number... it was horrible to even get the card
>> work, first no monitor mode works, but now it does (i dunno why
>> O_o)... The only thing i miss is Package injection.
>>
>> So my Question. Is it there? is it in the driver and i just have to do
>> some magic again like i did with the monitor mode?
>> If not, is there any Patch? (i didn't find anything...)
>> Or should i simply send the damn thing back and get me an 8187? (its
>> not that simple, and i like hacking into my linux, so one of the first
>> both, would be nicer)
>
> I found that packetspammer works just fine with rtl8192cu.
>
> Larry
>
>
