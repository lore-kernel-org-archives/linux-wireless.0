Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32152 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbJ2UAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 16:00:44 -0400
Message-ID: <56327AEA.305@broadcom.com> (sfid-20151029_210047_705897_05729A26)
Date: Thu, 29 Oct 2015 21:00:42 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] brcmfmac: new device support and cleanup
References: <1446147199-21671-1-git-send-email-arend@broadcom.com> <87h9l9o3pi.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87h9l9o3pi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2015 08:49 PM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> Here a smallish series which hopefully can make it in 4.4 release. The
>> highlights are:
>>
>> * support bcm4359 which can operate in two bands concurrently.
>> * disable runtime pm for USB avoiding issues.
>> * use generic pm callback in PCIe driver.
>> * support wowlan wake indication reporting.
>>
>> The series is intended for v4.4 and applies to the master branch
>> of the wireless-drivers-next repository.
>>
>> Hante Meuleman (9):
>>    brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
>>    brcmfmac: Simplify and fix usage of brcmf_ifname.
>>    brcmfmac: Remove unnecessary check from start_xmit.
>>    brcmfmac: Remove unncessary variable irq_requested.
>>    brcmfmac: Disable runtime pm for USB.
>>    brcmfmac: Add RSDB support.
>>    brcmfmac: Use consistent naming for bsscfgidx.
>>    brcmfmac: Use new methods for pcie Power Management.
>>    brcmfmac: Add wowl wake indication report.
>
> I just tagged a pull request to Dave which I hope to be the last one.
> Unless Linus delays the release I doubt these make it to 4.4, sorry.

I was afraid of that. Not a big deal. Seem to have a nose for late 
submissions ;-p

Regards,
Arend

