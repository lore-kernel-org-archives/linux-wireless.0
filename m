Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36842 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdHCKnV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:43:21 -0400
Received: by mail-vk0-f66.google.com with SMTP id z187so413023vkd.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 03:43:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fud9nedh.fsf@kamboji.qca.qualcomm.com>
References: <20170802122915.GA4759@symbol-HP-ZBook-15> <4d6b58d1-3e26-e6ea-0c0e-7e2b7aa3b75e@lwfinger.net>
 <87fud9nedh.fsf@kamboji.qca.qualcomm.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Thu, 3 Aug 2017 16:13:19 +0530
Message-ID: <CAFqt6zYasPxANN5mYsX-opg0vjV2mu_ZYCxG=idiGJwq5AE08w@mail.gmail.com> (sfid-20170803_124325_648257_6A861C45)
Subject: Re: [PATCH v5] rtlwifi: Replace hardcode value with macro
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 3, 2017 at 3:48 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> On 08/02/2017 07:29 AM, Souptick Joarder wrote:
>>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>>> and hw->max_rate_tries are replaced by macro and removed the comment.
>>>
>>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>>
>> Finally!
>>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> @Kalle: I'm sure you can work around this, but patchwork shows two
>> different "v5" versions and a "v4" entry for this same patch. That may
>> be due to no one formally rejecting the patch.
>
> It's because Souptick submitted two v5 patches, but yeah I can that sort
> it out.
>
> Souptick, the idea with patch versions is that maintainers and reviewers
> can easily find the latest version and drop the rest so ALWAYS increase
> the version number. Submitting duplicate version numbers defeats the
> purpose and creates extra work for others.

Noted. Thanks for the feedback.

>
> --
> Kalle Valo
