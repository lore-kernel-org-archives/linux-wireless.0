Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38911 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752850AbdBNJfz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 04:35:55 -0500
Received: by mail-it0-f45.google.com with SMTP id c7so27925143itd.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 01:35:54 -0800 (PST)
Subject: Re: [PATCH] iw: Fix bitrate output when no rate info found
To: Johannes Berg <johannes@sipsolutions.net>
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
 <1487061321.4705.1.camel@sipsolutions.net>
 <a2ffeab5-dd9c-1c9d-3fd1-c098a6d1e748@gmail.com>
 <1487063659.4705.5.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <e5c7bb68-73d9-48f1-3063-2617125ac14f@gmail.com> (sfid-20170214_103702_325107_5B5DEC65)
Date: Tue, 14 Feb 2017 18:35:51 +0900
MIME-Version: 1.0
In-Reply-To: <1487063659.4705.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-14 18:14, Johannes Berg wrote:
> Yes, this is bad! But if you saw that, why did you ever get to the
> below code that checked for the BITRATE(32) attributes?
>
>> So I used explaining message. We could see the message like this.
>>
>> tx bitrate: No rate info found!
>> rx bitrate: 48.0 MBit/s
>
> Yeah I was just thinking we could also see
>
> tx bitrate: (unknown)
>
> and then if there was MCS anyway you'd see
>
> tx bitrate: (unknown) MCS 7
>
> or something like that?

Yes, showing information as far as possible looks good.

I will modify this patch.

Masashi Honma.
