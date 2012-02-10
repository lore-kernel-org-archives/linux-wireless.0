Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4048 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2BJSVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 13:21:06 -0500
Message-ID: <4F356004.9090409@broadcom.com> (sfid-20120210_192110_745715_2570FCEA)
Date: Fri, 10 Feb 2012 10:20:52 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Kiss Robert" <kepten@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
In-Reply-To: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 10:53 AM, Kiss Robert wrote:
> On 2012-02-03 21:57:27, Franky Lin wrote:
>> Monitor mode is not supported in fullmac at the moment. I am afraid we
>> don't have an ETA as well. But if for mobile devices you mean Android
>> devices using Broadcom wifi chipset, current Android driver does have
>> monitor mode support.
>>
>> Franky
>
> Hi,
>
> Does that mean that the Android driver for bcm4330 has a working
> monitor mode already? Where can I download that?
>

Hi,

I need to correct my words after some digging. The Android version does 
*NOT* fully support monitor mode. It has some partial support there for 
P2P implementation. But some packets are held by the dongle because of 
filter offload. Sorry about the wrong info.

Regards,
Franky

