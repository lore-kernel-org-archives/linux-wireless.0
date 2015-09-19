Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36662 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbbISPFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 11:05:52 -0400
Received: by ioii196 with SMTP id i196so83455581ioi.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 08:05:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FD7000.7070305@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
	<CACna6rz6P4==K=fVr=Vnn8fkwvFJppEqub6dCEcZ8DyK5Bpa=Q@mail.gmail.com>
	<55FD7000.7070305@broadcom.com>
Date: Sat, 19 Sep 2015 17:05:51 +0200
Message-ID: <CACna6rxqZ08iFRwjaEpa4fLY8MCNU-tRm6X74y=FVCha2i7cig@mail.gmail.com> (sfid-20150919_170555_412122_97A8F4B4)
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 September 2015 at 16:24, Arend van Spriel <arend@broadcom.com> wrote:
> On 09/18/2015 11:29 PM, Rafał Miłecki wrote:
>> On 18 September 2015 at 22:08, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> * correct set and get tx-power.
>>
>>
>> Oh, I got a similar patch, you were faster :)
>>
>>
>>> The series should be applied to master branch of the
>>> wireless-drivers-next
>>> repository after the series sent earlier with
>>> Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
>>> and patch "brcmfmac: Reset PCIE devices after recognition." with
>>> Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.
>>
>>
>> Applied and tested with SR400ac (2 * BCM43602), no regressions
>> noticed. Nice work!o
>
>
> I replied to first and last patch so you are acknowledged for testing. Doing
> it for each patch in the series was too much trouble for me :-p

Sure. I didn't really bother because of old patchwork installed on
kernel.org. It doesn't understand UTF and malforms my name forcing
Kalle to fixup patches manually:
https://patchwork.kernel.org/patch/7220471/
https://patchwork.kernel.org/patch/7220401/

-- 
Rafał
