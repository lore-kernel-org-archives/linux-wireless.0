Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37377 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLUUOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 15:14:07 -0500
Received: by mail-ig0-f180.google.com with SMTP id h15so3098532igd.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 12:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <549725D1.2090402@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
	<1419162233-19492-4-git-send-email-arend@broadcom.com>
	<B1CB9465-1353-411C-9B3C-42DEFBFDBBE0@holtmann.org>
	<549725D1.2090402@broadcom.com>
Date: Sun, 21 Dec 2014 21:14:06 +0100
Message-ID: <CACna6rxjKUeDVGXGB5UzgOw1WyQKE+LYmtxJvTLW+H1fC7-13Q@mail.gmail.com> (sfid-20141221_211413_547578_CC7447F8)
Subject: Re: [PATCH 03/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 December 2014 at 20:56, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/21/14 18:50, Marcel Holtmann wrote:
>>
>> Hi Arend,
>>
>>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
>>> index 0f01fe0..61f8318 100644
>>> --- a/include/linux/mmc/sdio_ids.h
>>> +++ b/include/linux/mmc/sdio_ids.h
>>> @@ -29,6 +29,8 @@
>>> #define SDIO_DEVICE_ID_BROADCOM_4329            0x4329
>>> #define SDIO_DEVICE_ID_BROADCOM_4330            0x4330
>>> #define SDIO_DEVICE_ID_BROADCOM_4334            0x4334
>>> +#define SDIO_DEVICE_ID_BROADCOM_43340          43340
>>> +#define SDIO_DEVICE_ID_BROADCOM_43341          43341
>>
>>
>> the general preference is to have these values in hex. I get the fact that
>> they map the marketing number, but that could be just stated in a comment
>> after the hex number.
>
> Will change that.

I vote for keeping user-friendly numbers as comments :)
