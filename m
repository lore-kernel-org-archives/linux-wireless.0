Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:52853 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJaVJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 17:09:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1415764wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 14:09:38 -0700 (PDT)
Message-ID: <1ba2fa240810311409i5203bcccu2b944dcc505deb30@mail.gmail.com> (sfid-20081031_220945_108222_2C1000E3)
Date: Fri, 31 Oct 2008 23:09:38 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: Still 4965 issues with wireless-testing
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BF4BAA7D-FEBC-40F7-AE07-D6BBD31A2A0B@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
	 <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org>
	 <1ba2fa240810310652t351b0b77k819a7e03659503eb@mail.gmail.com>
	 <BF4BAA7D-FEBC-40F7-AE07-D6BBD31A2A0B@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 8:57 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Tomas,
>
>>>> so besides the point that the Ubuntu 8.10 kernel has a broken driver for
>>>> the Intel 4965 cards which will crash my X61 after less than one minute
>>>> uptime when it connects to my access point, I have my dmesg full with
>>>> warnings from the latest wireless-testing kernel.
>>>>
>>>> I know that we have discussed this before and Johannes' patch at least
>>>> turns it into warnings instead of killing my system completely, but I am
>>>> still surprised why this hasn't been fixed.
>>>
>>> so this becomes more and more annoying. I get this WARN_ON now multiple
>>> times pre minute. Only the first few minutes after loading the firmware
>>> everything is okay and then it keeps filling my dmesg. And on top of
>>> that, I
>>> now see these:
>>>
>>> __ratelimit: 1189 callbacks suppressed
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> __ratelimit: 57695 callbacks suppressed
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>> __ratelimit: 3345 callbacks suppressed
>>> iwlagn: Can not allocate SKB buffers
>>> iwlagn: Can not allocate SKB buffers
>>>
>>> What is going on here? This is a normal setup and nothing fancy. Access
>>> point is N-Capable from D-Link btw.
>>
>>
>> I have D-Link too I don't see this. What kernel version is this? Is
>> this your ubuntu version or wireless-testing?
>> Any more data you can provide (.config. slabinfo)
>
> this is from wireless-testing. The Ubuntu 2.6.27 kernel is totally broken.
> It will crash the kernel since we are missing the patch to turn this into a
> warning :)
>
> Attached is my config. The slabinfo will follow once the SKB errors come up
> again. It normally takes a few hours before they show. Just resumed that
> machine.

I've downloaded whole moblin last night over 2.6.27.4, it's a bit slow
because the missing calibrations but it didn't crashed.

I will test your config, your machine is T61  am I right?

Tomas
