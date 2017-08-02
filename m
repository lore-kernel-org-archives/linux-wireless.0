Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33580 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdHBKu2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:50:28 -0400
Received: by mail-qt0-f180.google.com with SMTP id a18so24575804qta.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 03:50:28 -0700 (PDT)
Message-ID: <5981AE72.5050002@broadcom.com> (sfid-20170802_125031_895849_B8FA098B)
Date: Wed, 02 Aug 2017 12:50:26 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Souptick Joarder <jrdr.linux@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] rtlwifi: Replace hardcode value with macro
References: <20170731111445.GA4844@symbol-HP-ZBook-15> <8af42486-dd0b-bda6-6125-148dc0011115@lwfinger.net> <87vam6496c.fsf@codeaurora.org> <CAFqt6zbiOEdOYzMa5a219=ROLv6BpJ9x0gdL3N61f+=_W8oK8w@mail.gmail.com>
In-Reply-To: <CAFqt6zbiOEdOYzMa5a219=ROLv6BpJ9x0gdL3N61f+=_W8oK8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/2/2017 12:47 PM, Souptick Joarder wrote:
> Hi Kalle,
>
> On Wed, Aug 2, 2017 at 2:51 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> On 07/31/2017 06:14 AM, Souptick Joarder wrote:
>>>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>>>> and hw->max_rate_tries are replaced by macro.
>>>
>>> That is NOT what your patch does. It only removes a comment! Granted,
>>> that comment is useless and should come out, but your commit message
>>> must be a little more accurate.
>>
>> Actually the patch does not even apply, I suspect that Souptick
>> incorrectly used v3 of his patch as the baseline for v4. Instead this v4
>> should be folded with v3.
>
> Do you mean I should address your comment in v3 and send v3 again
> instead of v4 ?

Your v4 patch should apply on top of wireless-drivers-next/master as is.

Regards,
Arend
