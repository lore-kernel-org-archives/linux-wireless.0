Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36142 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbHQIBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 04:01:49 -0400
Message-ID: <55D194EA.5070907@broadcom.com> (sfid-20150817_100202_894290_F0594688)
Date: Mon, 17 Aug 2015 10:01:46 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 0/7] brcmfmac: nvram loading and code rework
References: <1439708139-7527-1-git-send-email-arend@broadcom.com> <CACna6rxgTFan=xfidvfzFVRLBuJOWtDCyWe-unc-VeETrU_JQA@mail.gmail.com>
In-Reply-To: <CACna6rxgTFan=xfidvfzFVRLBuJOWtDCyWe-unc-VeETrU_JQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2015 05:10 PM, Rafał Miłecki wrote:
> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>> This series comprises of following changes:
>> - support NVRAM loading for bcm47xx platform.
>> - revise announced interface combinations and validate against it.
>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>> - couple of PCIe fixes.
>> - support more firmware events (for bcm4339 firmware).
>>
>> The series is intended for v4.3 kernel and applies to the master branch
>> of the wireless-drivers-next repository.
>
> Thanks! I'll be happy to test it with BCM43602 for regressions in 3-4
> days if you can wait that much.

You can still expect issues with multiple AP interfaces. I left one 
patch out of this series, because I am still investigating it.

Regards,
Arend

