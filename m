Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbJNLEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:04:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
	<561E1E69.3070108@osg.samsung.com>
	<87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
	<561E3481.4070008@osg.samsung.com>
Date: Wed, 14 Oct 2015 14:04:08 +0300
In-Reply-To: <561E3481.4070008@osg.samsung.com> (Javier Martinez Canillas's
	message of "Wed, 14 Oct 2015 12:54:57 +0200")
Message-ID: <87h9ltn23b.fsf@kamboji.qca.qualcomm.com> (sfid-20151014_130433_404835_2EA16198)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Martinez Canillas <javier@osg.samsung.com> writes:

> On 10/14/2015 12:52 PM, Kalle Valo wrote:
>> Javier Martinez Canillas <javier@osg.samsung.com> writes:
>> 
>>> Thanks for reporting this issue. I only did a partial build with
>>> make M=drivers/bcma but didn't think about implicit dependencies
>>> on other drivers.
>>>
>>> I've posted this patch that should avoid this issue:
>>> https://patchwork.kernel.org/patch/7391551/
>> 
>> So this patch ("bcma: mips: Allow build if COMPILE_TEST is enabled")
>> depend on that patch ("mtd: Make MTD_BCM47XXSFLASH to depend on MIPS"),
>> right? So I cannot apply the bcma patch until the mtd patch is in my
>> tree.
>
> That's correct, sorry for not stating it explicitly.

Ok, I put the patch now to "Awaiting Upstream" state in patchwork and
will apply it once I have the mtd patch.

-- 
Kalle Valo
