Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33980 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab2EAHWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 03:22:22 -0400
Received: by lahj13 with SMTP id j13so2332525lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 00:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9F6B67.5000400@lwfinger.net>
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
 <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net>
 <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com>
 <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
 <4F9F6B67.5000400@lwfinger.net>
From: simple w8 <simplew8@gmail.com>
Date: Tue, 1 May 2012 08:22:00 +0100
Message-ID: <CAKVccoVA=Rk8AkD+h0n9aeV95h0iMcnQgM_WMJq3rjzoFvkU-w@mail.gmail.com> (sfid-20120501_092226_382290_B97D9B7F)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/1 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/30/2012 10:40 PM, simple w8 wrote:
>>
>>
>> Its done, and i have reloaded the module, but how can i be sure/check
>> about the rtl8192ce parameters?
>
>
> When you 'modprobe -rv rtl8192ce && modprobe -v rtl8192ce', you will see the
> options listed.
>
> I do not use anything from Microsoft.
>
> You will need to bisect the differences between 3.3.1 and 3.3.2. I see all
> the local networks and cannot duplicate your problem. Thus, you will need to
> see what patch is causing the problem.

Well the problem while typing and having repeated characters and
sometimes the mouse frozen is gone when i runned that parameters for
rtl8192ce... finally a solution for that torment... well now you know
what was the cause and what needs to be fixed :)

Regarding the problem of kernel > 3.3.1 detect less wifi networks, i
will talk with the distro kernel maintainer to see if this can be some
caused by some patch that he adds to the distro kernel and then ill
let you know.
