Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:46138 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYJaNwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 09:52:54 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1208602wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 06:52:53 -0700 (PDT)
Message-ID: <1ba2fa240810310652t351b0b77k819a7e03659503eb@mail.gmail.com> (sfid-20081031_145258_595300_D17FCC78)
Date: Fri, 31 Oct 2008 15:52:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: Still 4965 issues with wireless-testing
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
	 <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 10:41 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi again,
>
>> so besides the point that the Ubuntu 8.10 kernel has a broken driver for
>> the Intel 4965 cards which will crash my X61 after less than one minute
>> uptime when it connects to my access point, I have my dmesg full with
>> warnings from the latest wireless-testing kernel.
>>
>> I know that we have discussed this before and Johannes' patch at least
>> turns it into warnings instead of killing my system completely, but I am
>> still surprised why this hasn't been fixed.
>
> so this becomes more and more annoying. I get this WARN_ON now multiple
> times pre minute. Only the first few minutes after loading the firmware
> everything is okay and then it keeps filling my dmesg. And on top of that, I
> now see these:
>
> __ratelimit: 1189 callbacks suppressed
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> __ratelimit: 57695 callbacks suppressed
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
> __ratelimit: 3345 callbacks suppressed
> iwlagn: Can not allocate SKB buffers
> iwlagn: Can not allocate SKB buffers
>
> What is going on here? This is a normal setup and nothing fancy. Access
> point is N-Capable from D-Link btw.


I have D-Link too I don't see this. What kernel version is this? Is
this your ubuntu version or wireless-testing?
Any more data you can provide (.config. slabinfo)
Thanks
Tomas
