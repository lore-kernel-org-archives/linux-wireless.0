Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53414 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3L2LwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 06:52:23 -0500
Received: by mail-lb0-f170.google.com with SMTP id c11so5055755lbj.15
        for <linux-wireless@vger.kernel.org>; Sun, 29 Dec 2013 03:52:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+icZUWR2dJ1=MhBfqdDzdmrFNM6_6kG2D4-VRt3wamFCxcrMA@mail.gmail.com>
References: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com>
	<CA+icZUUvK749V302H7s5etznVQYqN3bA5WYn04YCmcyydss-tg@mail.gmail.com>
	<CANUX_P1tqa+Y6gO_2XGYvF38r5hejYJjMmB2jhuO4vLirDQdwg@mail.gmail.com>
	<CA+icZUWR2dJ1=MhBfqdDzdmrFNM6_6kG2D4-VRt3wamFCxcrMA@mail.gmail.com>
Date: Sun, 29 Dec 2013 13:52:22 +0200
Message-ID: <CANUX_P3d94BXqmDULt0JrAqBMCbp-3eQHyB64tudrfkwzaamew@mail.gmail.com> (sfid-20131229_125226_216370_9A728E08)
Subject: Re: [ANN] New firmware for Intel 7260 / 3160
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Sun, Dec 29, 2013 at 1:50 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sun, Dec 29, 2013 at 12:47 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> We have released a new firmware for 3160 and for 7260 Intel devices.
>>>> This firmware includes the neww APIs we have been implementing for a while now.
>>>> We have here bug fixes along with better power save and P2P support.
>>>> Anyone who wants to use this firmware must have 3.13 at least.
>>>> The new file name is iwlwifi-{7260,3160}-8.ucode.
>>>> Just copy the file into /lib/firmware - if the driver / kernel
>>>> supports the new firmware, it will load the new one. If not,
>>>> iwlwifi-{7260,3160}-7.ucode will be loaded and everything should work
>>>> just fine.
>>>>
>>>> The firmware for 7260 is available at [1] and for 3160 at [2].
>>>> I encourage people running 3.13 and up to take the new firmware and
>>>> report issues.
>>>> The new firmware's version is 22.15.8.0:
>>>>
>>>> $ dmesg | grep loaded\ firmware
>>>> [ 8871.825758] iwlwifi 0000:02:00.0: loaded firmware version 22.15.8.0
>>>> op_mode iwlmvm
>>>>
>>>> [1] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.15.8.0.tgz
>>>> [2] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-3160-ucode-22.15.8.0.tgz
>>>>
>>>
>>> Shouldn't such stuff also go to the linux-firmware-folks?
>>>
>>
>> It will - don't worry. I already have a pull request pending to
>> linux-firmware anyway.
>> I'll add that new firmware to my fork of linux-firmware [1] tonight.
>>
>
> Good.
> For future announces like this one you can CC them?
>

I wasn't aware of such a mailing list. I usually send an announcement
on linux-wireless and then send a pull request to Ben Hutchings. If
you think I should change this process, I'd happy to know how to
improve it.
