Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2EAEtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 00:49:49 -0400
Received: by iadi9 with SMTP id i9so5004960iad.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 21:49:49 -0700 (PDT)
Message-ID: <4F9F6B67.5000400@lwfinger.net> (sfid-20120501_065025_605698_9FF4325F)
Date: Mon, 30 Apr 2012 23:49:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: simple w8 <simplew8@gmail.com>
CC: Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com> <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com> <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com> <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com> <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com> <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com> <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net> <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com> <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
In-Reply-To: <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2012 10:40 PM, simple w8 wrote:
>
> Its done, and i have reloaded the module, but how can i be sure/check
> about the rtl8192ce parameters?

When you 'modprobe -rv rtl8192ce && modprobe -v rtl8192ce', you will see the 
options listed.

I do not use anything from Microsoft.

You will need to bisect the differences between 3.3.1 and 3.3.2. I see all the 
local networks and cannot duplicate your problem. Thus, you will need to see 
what patch is causing the problem.

Larry



