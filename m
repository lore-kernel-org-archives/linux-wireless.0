Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:33018 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753306AbdFMOrd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:47:33 -0400
Received: by mail-qt0-f181.google.com with SMTP id u12so174948931qth.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:47:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lgowpeno.fsf@purkki.adurom.net>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
 <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com> <87lgowpeno.fsf@purkki.adurom.net>
From: amit karwar <amitkarwar@gmail.com>
Date: Tue, 13 Jun 2017 20:17:32 +0530
Message-ID: <CAEhWJFmzEotu+MpKaHqtXFnWyQWsekk23+Pj-3z8oEVmy2Z2DQ@mail.gmail.com> (sfid-20170613_164749_899768_1BCB7145)
Subject: Re: [PATCH 2/6] rsi: use enum for FSM states
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 13, 2017 at 12:17 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> Currently macros are used for FSM states. We will replace
>> it with enum so that new state can be added easily without
>> worrying about macro value.
>>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> From and Signed-off-by does not match (gmail.com vs redpinesignals.com).
> I suggest that you add a separate From line to the commit log containing
> redpinesignals.com, this way you can still submit patches via gmail.com.

Sure. I will follow this for my future patches.

>
> Also your name in patchwork is not capitalised (patchwork is idiotic and
> takes the name from patchwork user data and not from the patch):
>
>       [1/6] rsi: add usb RS9113 chipset support                    2017-06-02 amit karwar  New
>       [2/6] rsi: use enum for FSM states                           2017-06-02 amit karwar  New
>       [3/6] rsi: Register interrupt handler before firmware load   2017-06-02 amit karwar  New
>       [4/6] rsi: receive path enhancement for RS9113               2017-06-02 amit karwar  New
>       [5/6] rsi: configure new boot parameters to device           2017-06-02 amit karwar  New
>       [6/6] rsi: add tx frame for common device configuration      2017-06-02 amit karwar  New
>
> To fix that could you please register to patchwork and capitalise your
> name correctly? You have only one chance, patchwork doesn't allow users
> edit the name afterwards, so don't do any typos :)

Thanks. I have registered with patchwork and corrected my name.

Regards,
Amitkumar Karwar
