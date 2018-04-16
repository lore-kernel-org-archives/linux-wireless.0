Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:6873 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754834AbeDPNy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:54:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Josh Boyer <jwboyer@kernel.org>
CC: ojab // <ojab@ojab.ru>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>
Subject: Re: Compex WLE1216V2-20 (QCA9984) firmware is missing
Date: Mon, 16 Apr 2018 13:54:15 +0000
Message-ID: <87po2zp88o.fsf@kamboji.qca.qualcomm.com> (sfid-20180416_155429_766703_BA69177C)
References: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
        <CA+5PVA6nkGMzQHVu8LSaOUGU0h16rMeQvPoNORtyAzp8YDidOw@mail.gmail.com>
In-Reply-To: <CA+5PVA6nkGMzQHVu8LSaOUGU0h16rMeQvPoNORtyAzp8YDidOw@mail.gmail.com>       (Josh
 Boyer's message of "Mon, 16 Apr 2018 09:48:42 -0400")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Josh Boyer <jwboyer@kernel.org> writes:

> On Tue, Mar 27, 2018 at 12:41 PM, ojab // <ojab@ojab.ru> wrote:
>> [please CC me since I'm not subscribed to the lists and terribly sorry
>> for HTML mails]
>>
>> Oh hai!
>>
>> I have Compex WLE1216V2-20 (based on QCA9984 chip) that isn't
>> supported by linux-firmware (git master), card init fails with
>>
>>>[Mon Mar 26 17:18:47 2018] ath10k_pci 0000:05:00.0: failed to fetch
>> board data for bus=3Dpci,bmi-chip-id=3D0,bmi-board-id=3D30 from
>> ath10k/QCA9984/hw1.0/board-2.bin
>>
>> It works fine with board-2.bin from the compex website [1] (can be
>> downloaded directly from
>> https://bugzilla.kernel.org/attachment.cgi?id=3D274959).
>> What should be done to have it upstreamed?
>
> This is likely a question for Kalle.  I would expect an update to the
> existing board-2.bin file submitted through Qualcomm with support for
> that device.

Yes, this should have been sent to the ath10k list, not to
linux-firmware.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/support

--=20
Kalle Valo=
