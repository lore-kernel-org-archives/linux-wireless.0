Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33911 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbcAJVMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2016 16:12:15 -0500
Received: by mail-io0-f194.google.com with SMTP id k127so41364747iok.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2016 13:12:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5692C627.6050003@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
	<CACna6rzWKv7d7zjfJdnceLbknu+drbbjks_=JAkep0NiiLk7JA@mail.gmail.com>
	<5692C627.6050003@broadcom.com>
Date: Sun, 10 Jan 2016 22:12:14 +0100
Message-ID: <CACna6rxWJNo5vB+XH4nmL5bwqp5cmLO1O=V3XpB-NfFLeQVYDw@mail.gmail.com> (sfid-20160110_221219_038779_D1AA5E13)
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 January 2016 at 21:59, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/10/2016 12:48 AM, Rafał Miłecki wrote:
>>
>> On 18 September 2015 at 22:08, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> This series is intended for v4.4 containing the following highlights:
>>>
>>> * support for BCM4350, BCM4365, and BCM4366 PCIE devices.
>>> * fixed for legacy P2P and P2P device handling.
>>> * correct set and get tx-power.
>>
>>
>> Hi Arend, can you provide us some update on progress of releasing
>> brcmfmac4366b-pcie.bin, please?
>
>
> Sure. No progress. You also want to know about brcmfmac4365b-pcie.bin? Both
> devices are still in development or just taped-out if I am not mistaken
> (maybe missed a memo or two). I will ask for expected eta.

I'm not really interested in BCM4365 as I can't find any market device
using this chipset.

BCM4366 can be found in following devices:
ASUS RT-AC3100
ASUS RT-AC5300
ASUS RT-AC88U
D-Link DIR-885L rev A1
D-Link DIR-895L rev A1
Netgear R8500

You can already buy most of them in US, ASUS RT-AC5300 is also
available in Europe.

-- 
Rafał
