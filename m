Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40655 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaLVJFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 04:05:39 -0500
Message-ID: <5497DEE0.1040007@broadcom.com> (sfid-20141222_100545_864364_AE3B1FE1)
Date: Mon, 22 Dec 2014 10:05:36 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 03/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>	<1419162233-19492-4-git-send-email-arend@broadcom.com>	<B1CB9465-1353-411C-9B3C-42DEFBFDBBE0@holtmann.org>	<549725D1.2090402@broadcom.com> <CACna6rxjKUeDVGXGB5UzgOw1WyQKE+LYmtxJvTLW+H1fC7-13Q@mail.gmail.com>
In-Reply-To: <CACna6rxjKUeDVGXGB5UzgOw1WyQKE+LYmtxJvTLW+H1fC7-13Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/14 21:14, Rafał Miłecki wrote:
> On 21 December 2014 at 20:56, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 12/21/14 18:50, Marcel Holtmann wrote:
>>>
>>> Hi Arend,
>>>
>>>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
>>>> index 0f01fe0..61f8318 100644
>>>> --- a/include/linux/mmc/sdio_ids.h
>>>> +++ b/include/linux/mmc/sdio_ids.h
>>>> @@ -29,6 +29,8 @@
>>>> #define SDIO_DEVICE_ID_BROADCOM_4329            0x4329
>>>> #define SDIO_DEVICE_ID_BROADCOM_4330            0x4330
>>>> #define SDIO_DEVICE_ID_BROADCOM_4334            0x4334
>>>> +#define SDIO_DEVICE_ID_BROADCOM_43340          43340
>>>> +#define SDIO_DEVICE_ID_BROADCOM_43341          43341
>>>
>>>
>>> the general preference is to have these values in hex. I get the fact that
>>> they map the marketing number, but that could be just stated in a comment
>>> after the hex number.
>>
>> Will change that.
>
> I vote for keeping user-friendly numbers as comments :)

I don't see added value as the define id ends with the marketing number.

Regards,
Arend
