Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11188 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbcA1TCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 14:02:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
CC: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
	<linux-kernel@vger.kernel.org>,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
	<561E1E69.3070108@osg.samsung.com>
	<87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
	<561E3481.4070008@osg.samsung.com>
	<87h9ltn23b.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 28 Jan 2016 15:05:19 +0200
In-Reply-To: <87h9ltn23b.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 14 Oct 2015 14:04:08 +0300")
Message-ID: <87egd1lur4.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_200308_553566_8D746A3F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

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

I don't see "mtd: Make MTD_BCM47XXSFLASH to depend on MIPS" in 4.4-rc1.
I'll drop this now, please resend once the dependency patch is applied.

-- 
Kalle Valo
