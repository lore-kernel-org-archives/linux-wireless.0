Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42146 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2EAUhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 16:37:22 -0400
Received: by lbbgm6 with SMTP id gm6so1115155lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 13:37:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA00D48.1080402@lwfinger.net>
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
 <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net>
 <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com>
 <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
 <4F9F6B67.5000400@lwfinger.net> <CAKVccoVA=Rk8AkD+h0n9aeV95h0iMcnQgM_WMJq3rjzoFvkU-w@mail.gmail.com>
 <CAKVccoX=u=qX_OJ8RMSxpNEMGYdGVzimZURJ+ZeNZjhW1jPt6Q@mail.gmail.com>
 <4F9FF3D3.1020006@lwfinger.net> <CAKVccoUNwk7zKzckY-bNNvgf0FNDqZhnruzgTPOtxSXRuq3myQ@mail.gmail.com>
 <4FA00D48.1080402@lwfinger.net>
From: simple w8 <simplew8@gmail.com>
Date: Tue, 1 May 2012 21:37:00 +0100
Message-ID: <CAKVccoX8j95=Nhik=1OzbEHof=xf0H1Hm-ZjwXJaScqSS-JV6A@mail.gmail.com> (sfid-20120501_223738_503273_E8F4ACF6)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/1 Larry Finger <Larry.Finger@lwfinger.net>:
> On 05/01/2012 10:49 AM, simple w8 wrote:
>>
>> 2012/5/1 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> On 05/01/2012 08:36 AM, simple w8 wrote:
>>>>
>>>>
>>>>
>>>> SEams that was your last fix for rtl8192
>>>>
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=eb641120479de7ee703fabb5e6ee0ec7947474ba
>>>>   that reduced the wifi force, thus detecting less wifi networks.
>>>>
>>>> Running without that "fix" the notebook detects more wifi networks,
>>>> seams like the antenna have more force.
>>>
>>>
>>>
>>> You keep talking about "antenna force". What does that mean?
>>
>>
>> When i say that to refer to the machine power to capture, the power of
>> the wifi card to detect networks.
>>
>>> That patch keeps your device from running forever at a maximum of 1 Mbps
>>> by
>>> adjusting the initial gain of the RX amplifier. You may reverse it if you
>>> want so that you can detect more APs when you scan; however, most people
>>> prefer to get better performance from the device. That patch will not be
>>> reversed.
>>
>>
>> I see.
>>
>>> As to the problems with power saving, I cannot fix a problem if I cannot
>>> duplicate it. The locking in that section has been reviewed by several
>>> people, and there are no glaring errors. If disabling power saving makes
>>> your box work, then that is what you need to do. That is why those
>>> parameters can be set at load time.
>>
>>
>> But isnt strange that the wifi driver can interfere in the keyboard
>> when typing? and also be capable to interfere with the pointer device?
>
>
> Yes, but I cannot duplicate the problem. My experience is that unless I can
> do that, the probability of being able to fix it is very small. For example,
> it could be some interaction between the bridges for the PCIe and USB
> adapters. If so, it would be unique to your computer. If you want to ship me
> the box, I could probably work it out, but for now you should just use the
> work around.

I have another box with a different realtek wifi card in which happens
the same problem.
Im convinced that if you could run in one of these 2 wifi cards with a
microsoft mouse, you would be able to reproduce the problem.
