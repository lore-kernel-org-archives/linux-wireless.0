Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1947941AbdEZP0C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 11:26:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: amit karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v3 10/11] rsi: Add new firmware loading method
References: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494928877-27168-11-git-send-email-amit.karwar@redpinesignals.com>
        <87bmqi4q2u.fsf@purkki.adurom.net>
        <CAEhWJFnaG4xC71CL_ayYEyGg0HMNoyHK7aE9gcGAmsako8Q9Tw@mail.gmail.com>
Date: Fri, 26 May 2017 18:25:41 +0300
In-Reply-To: <CAEhWJFnaG4xC71CL_ayYEyGg0HMNoyHK7aE9gcGAmsako8Q9Tw@mail.gmail.com>
        (amit karwar's message of "Fri, 26 May 2017 20:40:11 +0530")
Message-ID: <87inknprm2.fsf@kamboji.qca.qualcomm.com> (sfid-20170526_172613_927144_551A8DE9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> writes:

> On Wed, May 24, 2017 at 1:57 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> The older firmware loading method has been deprecated and not in use
>>> for any chipets. New method is introduced which works based on soft
>>> boot loader. In this method, complete RAM image and FLASH image are
>>> present in the flash. Before loading the functional firmware, host
>>> issues boot loader commands to verify whether firmware to load is
>>> different from the current functional firmware. If not, firmware
>>> upgrade progresses and boot loader will switch to the new functional
>>> firmware.
>>>
>>> "rs9113_wlan_qspi.rps" is the firmware filename used in this patch.
>>
>> I don't know if you saw the discussion with the wil6210 firmware, but
>> the linux-firmware maintainers prefer to have a subdirectory for
>> firmware files. I'm planning to apply this series now, but you can send
>> a followup patch ASAP which changes the rsi driver to use a subdirectory
>> for the firmware files?
>
> I have just sent a follow up patch.

Thanks, I saw that. Will apply it shortly.

-- 
Kalle Valo
