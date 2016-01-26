Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34655 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbcAZCvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 21:51:10 -0500
Subject: Re: [PATCH V2 00/26] use unified firmware and add ops in cfg
To: Greg KH <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
 <87vb6hu7f0.fsf@purkki.adurom.net> <20160125172131.GA27361@kroah.com>
CC: <devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: glen lee <glen.lee@atmel.com>
Message-ID: <56A6DD8E.70607@atmel.com> (sfid-20160126_035114_005049_9C64BC1C)
Date: Tue, 26 Jan 2016 11:44:30 +0900
MIME-Version: 1.0
In-Reply-To: <20160125172131.GA27361@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2016년 01월 26일 02:21, Greg KH wrote:
> On Mon, Jan 25, 2016 at 03:15:31PM +0200, Kalle Valo wrote:
>> Glen Lee <glen.lee@atmel.com> writes:
>>
>>> This patch series contains
>>> * support suspend and resume functionality
>>> * use a unified firmware for all mode of operations(station, ap, p2p)
>>> * support Station/AP concurrency
>>> * increase link speed
>>> * add a cfg operation for adjusting the tx power
>>> * fix bug on p2p, WEP security and chaning virtual interface
>>>
>>> Changes in V2: details in each patch files.
>>>   - 0004-staging-wilc1000-add-sdio-resume-suspend.patch
>> It's good practise to also add "staging: wilc1000: " prefix to the cover
>> letter.
> Yes please, otherwise it misses my filters when I go to apply patches
> for a subsystem and I have to find it by hand :(

Oh, I see it helps to filter. I will add prefix also.
Do I need to resend V3 patch series with adding prefix to cover letter?

regards,
glen lee.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

