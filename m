Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52845 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbbJNLFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:05:02 -0400
Subject: Re: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
To: Kalle Valo <kvalo@codeaurora.org>
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
 <561E1E69.3070108@osg.samsung.com> <87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
 <561E3481.4070008@osg.samsung.com> <87h9ltn23b.fsf@kamboji.qca.qualcomm.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <561E36D8.1070100@osg.samsung.com> (sfid-20151014_130523_666614_19D14C6F)
Date: Wed, 14 Oct 2015 13:04:56 +0200
MIME-Version: 1.0
In-Reply-To: <87h9ltn23b.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kale,

On 10/14/2015 01:04 PM, Kalle Valo wrote:
> Javier Martinez Canillas <javier@osg.samsung.com> writes:
> 
>> On 10/14/2015 12:52 PM, Kalle Valo wrote:
>>> Javier Martinez Canillas <javier@osg.samsung.com> writes:
>>>
>>>> Thanks for reporting this issue. I only did a partial build with
>>>> make M=drivers/bcma but didn't think about implicit dependencies
>>>> on other drivers.
>>>>
>>>> I've posted this patch that should avoid this issue:
>>>> https://patchwork.kernel.org/patch/7391551/
>>>
>>> So this patch ("bcma: mips: Allow build if COMPILE_TEST is enabled")
>>> depend on that patch ("mtd: Make MTD_BCM47XXSFLASH to depend on MIPS"),
>>> right? So I cannot apply the bcma patch until the mtd patch is in my
>>> tree.
>>
>> That's correct, sorry for not stating it explicitly.
> 
> Ok, I put the patch now to "Awaiting Upstream" state in patchwork and
> will apply it once I have the mtd patch.
>

Great, thanks a lot for your help!
 
Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
