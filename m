Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:35687 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3L2LuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 06:50:16 -0500
Received: by mail-we0-f176.google.com with SMTP id p61so9236909wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 29 Dec 2013 03:50:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CANUX_P1tqa+Y6gO_2XGYvF38r5hejYJjMmB2jhuO4vLirDQdwg@mail.gmail.com>
References: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com>
	<CA+icZUUvK749V302H7s5etznVQYqN3bA5WYn04YCmcyydss-tg@mail.gmail.com>
	<CANUX_P1tqa+Y6gO_2XGYvF38r5hejYJjMmB2jhuO4vLirDQdwg@mail.gmail.com>
Date: Sun, 29 Dec 2013 12:50:14 +0100
Message-ID: <CA+icZUWR2dJ1=MhBfqdDzdmrFNM6_6kG2D4-VRt3wamFCxcrMA@mail.gmail.com> (sfid-20131229_125020_651208_EC3AAB96)
Subject: Re: [ANN] New firmware for Intel 7260 / 3160
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 29, 2013 at 12:47 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> Hi,
>>>
>>> We have released a new firmware for 3160 and for 7260 Intel devices.
>>> This firmware includes the neww APIs we have been implementing for a while now.
>>> We have here bug fixes along with better power save and P2P support.
>>> Anyone who wants to use this firmware must have 3.13 at least.
>>> The new file name is iwlwifi-{7260,3160}-8.ucode.
>>> Just copy the file into /lib/firmware - if the driver / kernel
>>> supports the new firmware, it will load the new one. If not,
>>> iwlwifi-{7260,3160}-7.ucode will be loaded and everything should work
>>> just fine.
>>>
>>> The firmware for 7260 is available at [1] and for 3160 at [2].
>>> I encourage people running 3.13 and up to take the new firmware and
>>> report issues.
>>> The new firmware's version is 22.15.8.0:
>>>
>>> $ dmesg | grep loaded\ firmware
>>> [ 8871.825758] iwlwifi 0000:02:00.0: loaded firmware version 22.15.8.0
>>> op_mode iwlmvm
>>>
>>> [1] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.15.8.0.tgz
>>> [2] - http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-3160-ucode-22.15.8.0.tgz
>>>
>>
>> Shouldn't such stuff also go to the linux-firmware-folks?
>>
>
> It will - don't worry. I already have a pull request pending to
> linux-firmware anyway.
> I'll add that new firmware to my fork of linux-firmware [1] tonight.
>

Good.
For future announces like this one you can CC them?

- Sedat -

> [1] - https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/
