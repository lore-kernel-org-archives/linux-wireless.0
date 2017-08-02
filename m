Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:35237 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdHBKrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:47:21 -0400
Received: by mail-ua0-f172.google.com with SMTP id d29so18787453uai.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 03:47:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vam6496c.fsf@codeaurora.org>
References: <20170731111445.GA4844@symbol-HP-ZBook-15> <8af42486-dd0b-bda6-6125-148dc0011115@lwfinger.net>
 <87vam6496c.fsf@codeaurora.org>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 2 Aug 2017 16:17:19 +0530
Message-ID: <CAFqt6zbiOEdOYzMa5a219=ROLv6BpJ9x0gdL3N61f+=_W8oK8w@mail.gmail.com> (sfid-20170802_124724_048600_E442CEC7)
Subject: Re: [PATCH v4] rtlwifi: Replace hardcode value with macro
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Aug 2, 2017 at 2:51 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> On 07/31/2017 06:14 AM, Souptick Joarder wrote:
>>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>>> and hw->max_rate_tries are replaced by macro.
>>
>> That is NOT what your patch does. It only removes a comment! Granted,
>> that comment is useless and should come out, but your commit message
>> must be a little more accurate.
>
> Actually the patch does not even apply, I suspect that Souptick
> incorrectly used v3 of his patch as the baseline for v4. Instead this v4
> should be folded with v3.

Do you mean I should address your comment in v3 and send v3 again
instead of v4 ?

>
> --
> Kalle Valo

-Souptick
