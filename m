Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16711 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbGZLIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 07:08:47 -0400
Message-ID: <55B4BFBC.2030107@broadcom.com> (sfid-20150726_131253_392172_6C68FD37)
Date: Sun, 26 Jul 2015 13:08:44 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>	<55AD2C8F.9010509@broadcom.com> <87bnf2hng8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnf2hng8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2015 06:02 PM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
>>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>> This series comprises of following changes:
>>>> - support NVRAM loading for bcm47xx platform.
>>>> - revise announced interface combinations and validate against it.
>>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>>> - couple of PCIe fixes.
>>>> - rework dealing with interface instances.
>>>
>>> I'm not sure which patch has caused this (I applied all of them except
>>> for the 1st one) but now brcmfmac fails totally:
>>>> Unable to handle kernel NULL pointer dereference at virtual address 00000014
>>>
>>> I'm afraid I won't be able to spend any more time of this soon, so can
>>> you try to reproduce this problem, please?
>>
>> So what is your scenario for this issue. Multiple AP interfaces?
>
> Arend, what should I do with this patchset?
>

Let's drop the series. I will resend when getting back to work. The 
combination of my sons condition and getting a little baby sister is 
quite impacting on our personal life so professional life has to wait.

Regards,
Arend

