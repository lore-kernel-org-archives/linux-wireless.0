Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58794 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbcA1S6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 13:58:30 -0500
Subject: Re: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
 <561E1E69.3070108@osg.samsung.com> <87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
 <561E3481.4070008@osg.samsung.com> <87h9ltn23b.fsf@kamboji.qca.qualcomm.com>
 <87egd1lur4.fsf@kamboji.qca.qualcomm.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56AA64CD.90409@osg.samsung.com> (sfid-20160128_195846_292405_65D4B3A0)
Date: Thu, 28 Jan 2016 15:58:21 -0300
MIME-Version: 1.0
In-Reply-To: <87egd1lur4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

On 01/28/2016 10:05 AM, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Javier Martinez Canillas <javier@osg.samsung.com> writes:
>>
>>> On 10/14/2015 12:52 PM, Kalle Valo wrote:
>>>> Javier Martinez Canillas <javier@osg.samsung.com> writes:
>>>>
>>>>> Thanks for reporting this issue. I only did a partial build with
>>>>> make M=drivers/bcma but didn't think about implicit dependencies
>>>>> on other drivers.
>>>>>
>>>>> I've posted this patch that should avoid this issue:
>>>>> https://patchwork.kernel.org/patch/7391551/
>>>>
>>>> So this patch ("bcma: mips: Allow build if COMPILE_TEST is enabled")
>>>> depend on that patch ("mtd: Make MTD_BCM47XXSFLASH to depend on MIPS"),
>>>> right? So I cannot apply the bcma patch until the mtd patch is in my
>>>> tree.
>>>
>>> That's correct, sorry for not stating it explicitly.
>>
>> Ok, I put the patch now to "Awaiting Upstream" state in patchwork and
>> will apply it once I have the mtd patch.
>
> I don't see "mtd: Make MTD_BCM47XXSFLASH to depend on MIPS" in 4.4-rc1.

Yeah, my patch started a very long discussion which has become too MIPS
specific for me to follow. The latest email from January 24 is [0].

> I'll drop this now, please resend once the dependency patch is applied.
>

Yeah, just drop the patch and I can resend if/when the discussion of the
first patch settles and someone fix it properly.

[0]: https://lkml.org/lkml/2016/1/24/320

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
