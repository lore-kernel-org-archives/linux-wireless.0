Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:38142 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbbAVUzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:55:47 -0500
Message-ID: <54C163D1.8010501@hauke-m.de> (sfid-20150122_215552_582393_E6D8F271)
Date: Thu, 22 Jan 2015 21:55:45 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] bcma: clean bus initialization code
References: <1421435929-21499-1-git-send-email-zajec5@gmail.com>	<1421438379-26211-1-git-send-email-zajec5@gmail.com>	<54BBFCE5.9050500@hauke-m.de> <87ppa6ncd5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ppa6ncd5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2015 03:01 PM, Kalle Valo wrote:
> Hauke Mehrtens <hauke@hauke-m.de> writes:
> 
>> On 01/16/2015 08:59 PM, Rafał Miłecki wrote:
>>> This moves main bus init code to the main.c and renames old function to
>>> make its purpose clear.
>>> Thanks to this change we'll also be able to separate scanning from
>>> registration (and support PCIe Gen 2 devices) in the future.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> No need to change anything now, but I think that in cases like this you
> should use Acked-by:
> 
>   "13) When to use Acked-by: and Cc:
> 
>   The Signed-off-by: tag indicates that the signer was involved in the
>   development of the patch, or that he/she was in the patch's delivery
>   path.
> 
>   If a person was not directly involved in the preparation or handling
>   of a patch but wishes to signify and record their approval of it then
>   they can arrange to have an Acked-by: line added to the patch's
>   changelog.
> 
>   Acked-by: is often used by the maintainer of the affected code when
>   that maintainer neither contributed to nor forwarded the patch."
> 
> 
Yes you are right I thought about that right after I send clicked on
send. Sorry.

Hauke
