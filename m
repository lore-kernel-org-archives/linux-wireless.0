Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59040 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbEHRyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 13:54:36 -0400
Message-ID: <554CF858.4020508@broadcom.com> (sfid-20150508_195439_743192_4C91D07D)
Date: Fri, 8 May 2015 19:54:32 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: <linux-firmware@kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] brcm: firmware for brcmfmac driver
References: <1429518626-15321-1-git-send-email-arend@broadcom.com> <20150508163924.GG27807@merlin.infradead.org>
In-Reply-To: <20150508163924.GG27807@merlin.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/15 18:39, Kyle McMartin wrote:
> On Mon, Apr 20, 2015 at 10:30:22AM +0200, Arend van Spriel wrote:
>> Couple of new firmware files for devices added to brcmfmac and
>> replacing a firmware file that turned out to be not working on
>> the intended device.
>>
>> This patch applies to the master branch of the linux-firmware
>> repository on top of commit ec89525b2ab6 ("firmware: WHENCE: note
>> nvidia xusb.bin firmware versions").
>>
>
> Applied, sorry for the delay.

I was considering a ping, but did not want to interrupt my vacation ;-)

Thanks,
Arend

> regards, --Kyle
>
>> Arend van Spriel (4):
>>    brcm: add firmware for BCM43569 USB device
>>    brcm: add firmware for BCM43570 PCIe device
>>    brcm: replace non-working firmware for BCM4339
>>    brcm: add firmware for BCM4324(1) B5 chipset
>>
>>   WHENCE                        |   2 ++
>>   brcm/brcmfmac43241b5-sdio.bin | Bin 0 ->  408682 bytes
>>   brcm/brcmfmac4339-sdio.bin    | Bin 569291 ->  493599 bytes
>>   brcm/brcmfmac43569.bin        | Bin 0 ->  557056 bytes
>>   brcm/brcmfmac43570-pcie.bin   | Bin 0 ->  550333 bytes
>>   5 files changed, 2 insertions(+)
>>   create mode 100644 brcm/brcmfmac43241b5-sdio.bin
>>   rewrite brcm/brcmfmac4339-sdio.bin (91%)
>>   create mode 100644 brcm/brcmfmac43569.bin
>>   create mode 100644 brcm/brcmfmac43570-pcie.bin
>>
>> --
>> 1.9.1
>>
>>

