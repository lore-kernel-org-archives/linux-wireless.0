Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35171 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGFOwq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:52:46 -0400
Received: by mail-qk0-f173.google.com with SMTP id 16so4239075qkg.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87tw302caj.fsf@purkki.adurom.net>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
 <1497624881-2315-8-git-send-email-amit.karwar@redpinesignals.com> <87tw302caj.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 6 Jul 2017 20:22:44 +0530
Message-ID: <CAEhWJFmFNXAN6gUfFzst9-TUL_U7uR1ieG4ZqMzzQF=87E-qEg@mail.gmail.com> (sfid-20170706_165249_209514_9A083FD3)
Subject: Re: [v2 07/20] rsi: correct the logic of deriving queue number
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:02 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> Maximum valid queue number is 0x5. So anding with 0x7 should be
>> ok here.
>>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> The separate From header is missing which you had in v1.

Thanks. This is corrected in v3.

Regards,
Amitkumar
