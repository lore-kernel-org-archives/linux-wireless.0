Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37261 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbHQOZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:25:04 -0400
Received: by igui7 with SMTP id i7so56301450igu.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2015 07:25:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D194EA.5070907@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
	<CACna6rxgTFan=xfidvfzFVRLBuJOWtDCyWe-unc-VeETrU_JQA@mail.gmail.com>
	<55D194EA.5070907@broadcom.com>
Date: Mon, 17 Aug 2015 16:25:03 +0200
Message-ID: <CACna6rwur0X06Yo68UU8XW7tg9Lk41fsPRdLE39=D+pLxQb9oQ@mail.gmail.com> (sfid-20150817_162508_472079_6D43A299)
Subject: Re: [PATCH V2 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 August 2015 at 10:01, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/16/2015 05:10 PM, Rafał Miłecki wrote:
>>
>> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>> This series comprises of following changes:
>>> - support NVRAM loading for bcm47xx platform.
>>> - revise announced interface combinations and validate against it.
>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>> - couple of PCIe fixes.
>>> - support more firmware events (for bcm4339 firmware).
>>>
>>> The series is intended for v4.3 kernel and applies to the master branch
>>> of the wireless-drivers-next repository.
>>
>>
>> Thanks! I'll be happy to test it with BCM43602 for regressions in 3-4
>> days if you can wait that much.
>
>
> You can still expect issues with multiple AP interfaces. I left one patch
> out of this series, because I am still investigating it.

Thanks for info. If it's an old issue, that's fine. If it's going to
be a regression, then we shouldn't push these changes.
As I said, I just want to check for regressions :)

-- 
Rafał
