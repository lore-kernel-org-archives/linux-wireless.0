Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752506AbeFZI0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 04:26:09 -0400
Subject: Re: [PATCH] arm64: dts: hikey: Define wl1835 power capabilities
To: John Stultz <john.stultz@linaro.org>, Ryan Grachek <ryan@edited.us>
References: <20180613151305.17240-1-ryan@edited.us>
 <CANcMJZASEDRxaXwdG96nNeEDPrDm_ap5MjhXonEcg=yHZ8F=qg@mail.gmail.com>
 <CALAqxLWjJKsU+XJmANzx-aO2ruszwbBnPV2yV5WoyVStO+5K0A@mail.gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eyal Reizer <eyalr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>
From: Wei Xu <xuwei5@hisilicon.com>
Message-ID: <5B31F888.7010403@hisilicon.com> (sfid-20180626_102648_300592_99F81056)
Date: Tue, 26 Jun 2018 09:25:44 +0100
MIME-Version: 1.0
In-Reply-To: <CALAqxLWjJKsU+XJmANzx-aO2ruszwbBnPV2yV5WoyVStO+5K0A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On 2018/6/25 22:56, John Stultz wrote:
> On Wed, Jun 13, 2018 at 11:30 AM, John Stultz <john.stultz@linaro.org> wrote:
>> On Wed, Jun 13, 2018 at 8:13 AM, Ryan Grachek <ryan@edited.us> wrote:
>>> These properties are required for compatibility with runtime PM.
>>> Without these properties, MMC host controller will not be aware
>>> of power capabilities. When the wlcore driver attempts to power
>>> on the device, it will erroneously fail with -EACCES.
>>>
>>> Signed-off-by: Ryan Grachek <ryan@edited.us>
>>
>> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
>> Tested-by: John Stultz <john.stultz@linaro.org>
>> Acked-by: John Stultz <john.stultz@linaro.org>
>>
>> Wei Xu: This fixes a functional regression with wifi on the HiKey
>> board that was introduced in 4.18-rc with commit 60f36637bbbd
>> ("wlcore: sdio: allow pm to handle sdio power").
> 
> Wei Xu: Just wanted to follow up to make sure this wasn't missed for
> 4.18-rc, as I haven't seen it upstream or in -next, and it fixes a
> recently introduced regression.

Thanks!
I will send out the fix pull request in these two days if no problem.

Best Regards,
Wei

> 
> thanks
> -john
> 
> .
> 
