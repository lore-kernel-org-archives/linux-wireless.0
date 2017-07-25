Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdGYIba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 04:31:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Quentin Schulz <quentin.schulz@free-electrons.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        shawn.lin@rock-chips.com, adrian.hunter@intel.com,
        baolin.wang@linaro.org, Hans de Goede <hdegoede@redhat.com>,
        maxime.ripard@free-electrons.com,
        thomas.petazzoni@free-electrons.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, devel@driverdev.osuosl.org,
        icenowy@aosc.xyz, wens@csie.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: net: wireless: add ESP8089 WiFi driver
References: <20170721143502.1991-1-quentin.schulz@free-electrons.com>
        <20170721143502.1991-2-quentin.schulz@free-electrons.com>
        <20170721150133.GA18198@kroah.com>
        <ab1c22b6-9208-6f99-9422-688195ad98f7@free-electrons.com>
        <34C896A9-0FFE-4174-8E08-A07A12C4A7ED@holtmann.org>
        <37e6e8f9-8f36-cb78-276d-01f4656c6e47@free-electrons.com>
Date: Tue, 25 Jul 2017 11:31:22 +0300
In-Reply-To: <37e6e8f9-8f36-cb78-276d-01f4656c6e47@free-electrons.com>
        (Quentin Schulz's message of "Fri, 21 Jul 2017 19:05:26 +0200")
Message-ID: <87k22wyl2d.fsf@purkki.adurom.net> (sfid-20170725_104618_414307_34346FC8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding linux-wireless)

Quentin Schulz <quentin.schulz@free-electrons.com> writes:

> Hi Marcel,
>
> On 21/07/2017 18:52, Marcel Holtmann wrote:
>> Hi Quentin,
>> 
>>>>> The Espressif ESP8089 WiFi chips can be often found in cheap tablets.
>>>>> There is one in A23 Polaroid tablets for example.
>>>>>
>>>>> The chip is often embedded as an eMMC SDIO device.
>>>>>
>>>>> The code was taken from an out-of-tree repository and has seen a first
>>>>> pass in the cleanup process.
>>>>>
>>>>> At the moment, there is no publicly available datasheet for this chip.
>>>>>
>>>>> Cc: Hans de Goede <hdegoede@redhat.com>
>>>>> Cc: Icenowy Zheng <icenowy@aosc.xyz>
>>>>> Signed-off-by: Quentin Schulz <quentin.schulz@free-electrons.com>
>>>>
>>>> Staging drivers need a TODO file that lists what has to be done to the
>>>> code to get it out of staging.  Why not just take a day or so and fix up
>>>> the remaining issues and get it into the "real" part of the kernel
>>>> correctly?
>>>>
>>>
>>> OK, I'll work on a TODO list. Is there anything else I should know about
>>> staging drivers so I can address everything at the same time?
>>>
>>> From a driver that has already been cleaned up a bit by Icenowy and
>>> Hans, it took me between 10 and 15 working days to this step, which I
>>> estimate to be around 50% of total clean up (and we're only speaking
>>> about coding style and dead code mainly, nothing about a bit of code
>>> review, code robustness...). I find the code not really easy to follow
>>> (might be because I'm a beginner in the subsystem as well).
>>>
>>> I might not be the most efficient person in cleaning up drivers but I'm
>>> pretty sure this isn't a one day cleanup. (Would be happy to be proven
>>> otherwise :) ), else I would have done it as you suggest.
>> 
>> even if it takes you 1 month to clean it up, get it reviewed on
>> linux-wireless and target wireless-drivers instead of staging. When I
>> had a brief a look at your patch, it didn't look like staging
>> material to me.

I did only a 30 sec review (right now no time for proper review because
I have quite a lot of catching up after vacation) but based on what I
saw the driver looks promising. So I agree with Marcel, you should try
to submit this via linux-wireless first and only use staging as the last
resort.

> We don't have a client supporting this effort and I don't think the
> company I work for would support this effort (maybe it would, but
> definitely spread over a long long period), so we're talking about 10-15
> working days spread over my free time/week-end, that isn't for in one
> month :) I could use help for sure on this driver, that's why I posted
> it in staging.
>
> I've done the cleanup on a per-file basis so maybe you looked at one of
> the cleaned up files?
>
> Just to be sure, you're telling me that I should post it as is on
> linux-wireless and then work with the reviews? Or are you telling me to
> take "1 month to clean it up" and then post it on linux-wireless?

I recommend to post the patch to linux-wireless now and see what
comments you get. Then I can also when a proper review and have better
guidance.

-- 
Kalle Valo
