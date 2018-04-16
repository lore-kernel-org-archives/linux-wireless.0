Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:37700 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbeDPN7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:59:32 -0400
Received: by mail-ua0-f169.google.com with SMTP id d3so9820197uae.4
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 06:59:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87po2zp88o.fsf@kamboji.qca.qualcomm.com>
References: <CAKzrAgSbYN1znJi8qM0QEfCniw2AGEKnrh-vJcUcXW0rVmo9tQ@mail.gmail.com>
 <CA+5PVA6nkGMzQHVu8LSaOUGU0h16rMeQvPoNORtyAzp8YDidOw@mail.gmail.com> <87po2zp88o.fsf@kamboji.qca.qualcomm.com>
From: "ojab //" <ojab@ojab.ru>
Date: Mon, 16 Apr 2018 13:59:31 +0000
Message-ID: <CAKzrAgSYb1Pt2chr4OGzBOfCYpy9YFhJJnaAN2jxn1QraPDPoQ@mail.gmail.com> (sfid-20180416_155935_539850_00A13D45)
Subject: Re: Compex WLE1216V2-20 (QCA9984) firmware is missing
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Josh Boyer <jwboyer@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2018 at 1:54 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Josh Boyer <jwboyer@kernel.org> writes:
>
>> On Tue, Mar 27, 2018 at 12:41 PM, ojab // <ojab@ojab.ru> wrote:
>>> [please CC me since I'm not subscribed to the lists and terribly sorry
>>> for HTML mails]
>>>
>>> Oh hai!
>>>
>>> I have Compex WLE1216V2-20 (based on QCA9984 chip) that isn't
>>> supported by linux-firmware (git master), card init fails with
>>>
>>>>[Mon Mar 26 17:18:47 2018] ath10k_pci 0000:05:00.0: failed to fetch
>>> board data for bus=pci,bmi-chip-id=0,bmi-board-id=30 from
>>> ath10k/QCA9984/hw1.0/board-2.bin
>>>
>>> It works fine with board-2.bin from the compex website [1] (can be
>>> downloaded directly from
>>> https://bugzilla.kernel.org/attachment.cgi?id=274959).
>>> What should be done to have it upstreamed?
>>
>> This is likely a question for Kalle.  I would expect an update to the
>> existing board-2.bin file submitted through Qualcomm with support for
>> that device.
>
> Yes, this should have been sent to the ath10k list, not to
> linux-firmware.
>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/support

Thanks, sent the same email there.
