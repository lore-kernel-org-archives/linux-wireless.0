Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:57044 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdJaSFn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 14:05:43 -0400
Received: by mail-yw0-f194.google.com with SMTP id l32so15495238ywh.13
        for <linux-wireless@vger.kernel.org>; Tue, 31 Oct 2017 11:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8760avs5m7.fsf@purkki.adurom.net>
References: <1509103557-6215-2-git-send-email-amitkarwar@gmail.com>
 <20171030105050.556356028C@smtp.codeaurora.org> <8760avs5m7.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 31 Oct 2017 23:35:42 +0530
Message-ID: <CAEhWJFkXBMpd7yVccQCr3GJ8kzibTA_NY17posOrM1DfAKch9Q@mail.gmail.com> (sfid-20171031_190605_213345_3D33C39B)
Subject: Re: [v3,1/3] rsi: sdio: add WOWLAN support for S3 suspend state
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 31, 2017 at 8:54 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Amitkumar Karwar <amitkarwar@gmail.com> wrote:
>>
>>> From: Karun Eagalapati <karun256@gmail.com>
>>>
>>> WoWLAN is supported in RS9113 device through GPIO pin2.
>>> wowlan config frame is internally sent to firmware in mac80211
>>> suspend handler. Also beacon miss threshold and keep-alive time
>>> values are increased to avoid un-necessary disconnection with AP.
>>>
>>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>
>> 3 patches applied to wireless-drivers-next.git, thanks.
>>
>> f3ac4e7394a1 rsi: sdio: add WOWLAN support for S3 suspend state
>> b6c8d06c8a64 rsi: sdio: Add WOWLAN support for S4 hibernate state
>> 063848c3e155 rsi: sdio: Add WOWLAN support for S5 shutdown state
>
> Kbuild bot found build problems with the first patch. (Amit should have
> the details in the mail from kbuild bot.) I need a fix by tomorrow
> (wednesday) or I need to revert these. Otherwise I cannot submit a pull
> request to Dave.
>

I'll submit a fix for this by tomorrow.

Regards,
Amit
