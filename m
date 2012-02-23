Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62556 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BWQBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 11:01:06 -0500
Received: by ghrr11 with SMTP id r11so653565ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 08:01:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F356004.9090409@broadcom.com>
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
 <4F356004.9090409@broadcom.com>
From: Kiss Robert <kepten@gmail.com>
Date: Thu, 23 Feb 2012 17:00:45 +0100
Message-ID: <CAN+AqrVLeJYQFLHqtmuhWQ_34x-6bG1uiYRJxj3zRvNJXknpPQ@mail.gmail.com> (sfid-20120223_170110_592094_5817D19F)
Subject: Re: Broadcom brcm80211 monitor mode
To: Franky Lin <frankyl@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the answer!
I have read somewhere that the Broadcom 4330 chipset on Samsung Galaxy
S II cannot be put to monitor mode because of some hardware
limitation. Is that true? Can someone confirm that?

Regards,

Robert

On 10 February 2012 19:20, Franky Lin <frankyl@broadcom.com> wrote:
> On 02/08/2012 10:53 AM, Kiss Robert wrote:
>>
>> On 2012-02-03 21:57:27, Franky Lin wrote:
>>>
>>> Monitor mode is not supported in fullmac at the moment. I am afraid we
>>> don't have an ETA as well. But if for mobile devices you mean Android
>>> devices using Broadcom wifi chipset, current Android driver does have
>>> monitor mode support.
>>>
>>> Franky
>>
>>
>> Hi,
>>
>> Does that mean that the Android driver for bcm4330 has a working
>> monitor mode already? Where can I download that?
>>
>
> Hi,
>
> I need to correct my words after some digging. The Android version does
> *NOT* fully support monitor mode. It has some partial support there for P2P
> implementation. But some packets are held by the dongle because of filter
> offload. Sorry about the wrong info.
>
> Regards,
> Franky
>
