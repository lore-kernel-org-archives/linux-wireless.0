Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760332Ab0HLQG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 12:06:56 -0400
Received: from mail-gw0-f46.google.com (mail-gw0-f46.google.com [74.125.83.46])
	(authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o7CG6Wn4029029
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2010 09:06:33 -0700
Received: by gwb20 with SMTP id 20so469069gwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2010 09:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 09:06:07 -0700
Message-ID: <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
To: Gauss Frank <gaussfrank@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jerry chuang <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 12, 2010 at 3:24 AM, Gauss Frank <gaussfrank@gmail.com> wrote:
> I'm using Debian and Ubuntu.
>
> In Ubuntu, I compiled Linux 2.6.35-1,which contains RealTek 8192U Wireless
> Driver. I'd installed firmware for r8192u, and I tried to connect to
> wireless.
>
> However, whenever I connect to a wireless-network, The Linux System freezes.
> And the computer can keep only a few time and it must freezes without
> connecting to a wireless network.
>
> I'm using Debian Lenny with an old version of Linux Kernel,2.6.26-2. I
> downloaded the old driver(2008) in www.d-link.com, and compiled, which can't
> be compiled in new Linux Kernel because of some struct or union redefined.
> and it runs well.
>
> So I make sure that the problem is from Linux Kernel or The Driver.

Please don't send reports like this to me privately, there's no point.
I won't be able to fix individual drivers that I don't know. Make a
public report, and try to figure out who is in charge of that driver.

I've added the most active rtl8192 authors/people to the Cc, along
with linux-wireless. Hopefully that includes somebody who can help.

                                        Linus
