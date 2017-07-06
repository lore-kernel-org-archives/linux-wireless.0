Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36002 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdGFOxv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:53:51 -0400
Received: by mail-qk0-f175.google.com with SMTP id p21so4230192qke.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:53:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lgoc2c4c.fsf@purkki.adurom.net>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
 <1497624881-2315-12-git-send-email-amit.karwar@redpinesignals.com>
 <87podo2c6v.fsf@purkki.adurom.net> <87lgoc2c4c.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 6 Jul 2017 20:23:48 +0530
Message-ID: <CAEhWJFmApGmouvqqyYqAJBRak3ZB51Gt5kLBOYAsX1AaxiK+hw@mail.gmail.com> (sfid-20170706_165354_467086_E42AAC6C)
Subject: Re: [v2 11/20] rsi: management frame descriptor preparation cleanup
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:06 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
>>>
>>> Currently this descriptor is prepared with the help of __le16
>>> pointer. This patch makes use of a structure to prepare the
>>> descriptor in a cleaner way.
>>>
>>> Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>
>> Pavani's name is in wrong format both in Format and S-o-b lines.
>
> Seems to be in every patch from Pavani in this set.

I have fixed this in v3.

Regards,
Amitkumar
