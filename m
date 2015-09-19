Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:44774 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbbISQdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 12:33:00 -0400
Message-ID: <55FD8E39.2010104@broadcom.com> (sfid-20150919_183304_746764_F5CE1ED7)
Date: Sat, 19 Sep 2015 18:32:57 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>	<CACna6rz6P4==K=fVr=Vnn8fkwvFJppEqub6dCEcZ8DyK5Bpa=Q@mail.gmail.com>	<55FD7000.7070305@broadcom.com> <CACna6rxqZ08iFRwjaEpa4fLY8MCNU-tRm6X74y=FVCha2i7cig@mail.gmail.com>
In-Reply-To: <CACna6rxqZ08iFRwjaEpa4fLY8MCNU-tRm6X74y=FVCha2i7cig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2015 05:05 PM, Rafał Miłecki wrote:
> On 19 September 2015 at 16:24, Arend van Spriel <arend@broadcom.com> wrote:
>> On 09/18/2015 11:29 PM, Rafał Miłecki wrote:
>>> On 18 September 2015 at 22:08, Arend van Spriel <arend@broadcom.com>
>>> wrote:
>>>>
>>>> * correct set and get tx-power.
>>>
>>>
>>> Oh, I got a similar patch, you were faster :)
>>>
>>>
>>>> The series should be applied to master branch of the
>>>> wireless-drivers-next
>>>> repository after the series sent earlier with
>>>> Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
>>>> and patch "brcmfmac: Reset PCIE devices after recognition." with
>>>> Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.
>>>
>>>
>>> Applied and tested with SR400ac (2 * BCM43602), no regressions
>>> noticed. Nice work!o
>>
>>
>> I replied to first and last patch so you are acknowledged for testing. Doing
>> it for each patch in the series was too much trouble for me :-p
>
> Sure. I didn't really bother because of old patchwork installed on
> kernel.org. It doesn't understand UTF and malforms my name forcing
> Kalle to fixup patches manually:
> https://patchwork.kernel.org/patch/7220471/
> https://patchwork.kernel.org/patch/7220401/

So the patchwork upgrade request did not get through yet ;-)

Regards,
Arend

