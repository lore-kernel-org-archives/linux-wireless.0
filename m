Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:35475 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbbAFTHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 14:07:37 -0500
Message-ID: <54AC3275.7040802@broadcom.com> (sfid-20150106_200742_539137_44FC8E1D)
Date: Tue, 6 Jan 2015 20:07:33 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] brcmfmac: new device support and more
References: <1419162233-19492-1-git-send-email-arend@broadcom.com> <87fvbnycvr.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvbnycvr.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/15 19:36, Kalle Valo wrote:
> Arend van Spriel<arend@broadcom.com>  writes:
>
>> Here a first batch for v3.20. This series adds support for the
>> BCM43340 and BCM43341 SDIO chipsets. A number of changes are
>> related to AP mode and some fixes of potential issues that do
>> not seem to qualify for the wireless tree.
>>
>> This series is intended for v3.20 and applies to the master
>> branch of the *new* wireless-next repository.
>>
>> Arend van Spriel (5):
>>    brcmfmac: Add support for bcm43340/1 wireless chipsets
>>    brcmfmac: get rid of duplicate SDIO device identifiers
>>    brcmfmac: remove unused/duplicate defines in chip.c
>>    brcmfmac: follow user-space regulatory domain selection
>>    brcmfmac: enable 802.11d support in firmware
>>
>> Hante Meuleman (5):
>>    brcmfmac: Fix incorrect casting of 64 bit physical address.
>>    brcmfmac: Fix possible dereference of NULL pointer.
>>    brcmfmac: Fix WEP configuration for AP mode.
>>    brcmfmac: Change error log in standard log for rxbufpost.
>>    brcmfmac: signal completion of 802.1x.
>
> I applied these patches:
>
> 98027769828f brcmfmac: enable 802.11d support in firmware
> 6b89dcb35bfc brcmfmac: signal completion of 802.1x.
> 63db1a499cee brcmfmac: follow user-space regulatory domain selection
> d2e2472cd197 brcmfmac: Change error log in standard log for rxbufpost.
> 118eb304d055 brcmfmac: Fix WEP configuration for AP mode.
> f714e58e19a5 brcmfmac: remove unused/duplicate defines in chip.c
> 83297aaa8fde brcmfmac: Fix incorrect casting of 64 bit physical address.
>
> I dropped two due based on discussion and one patch didn't apply.
>
Thanks, Kalle

I will resend that last one mentioned. Probably depends on (one of) the 
two dropped patches.

Regards,
Arend

