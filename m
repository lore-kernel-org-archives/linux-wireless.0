Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbeDWOKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 10:10:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        luciano.coelho@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: New sparse warning from min_t(): expression using sizeof(void)
References: <87a7txf15w.fsf@kamboji.qca.qualcomm.com>
        <20180421082444.i4eyw2zxl6tipt6i@gmail.com>
        <87604ley7t.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 23 Apr 2018 17:10:39 +0300
In-Reply-To: <87604ley7t.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Sat, 21 Apr 2018 11:54:30 +0300")
Message-ID: <87d0yqdnds.fsf@kamboji.qca.qualcomm.com> (sfid-20180423_161055_274651_7AC871B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Joey Pabalinas <joeypabalinas@gmail.com> writes:
>
>> On Sat, Apr 21, 2018 at 10:50:51AM +0300, Kalle Valo wrote:
>>> Is there any way to fix it? With ath10k I use sparse a lot and because
>>> of these warnings sparse is now very annoying to use.
>>
>> I submitted a sparse patch [1] for this not too long ago, but in the
>> meantime you can still curl the patch [2] and apply it directly to
>> the v0.5.2 release to suppress the deluge of warnings (-Wpointer-arith
>> is off by defaultl so no need to change any of you configurations).
>>
>> [1] https://lkml.org/lkml/2018/4/10/923
>> [2] https://patchwork.kernel.org/patch/10334353/raw/
>
> Perfect, thanks. Unfortunatelly I need to catch a boat and I can't test
> it right now, but I'll do that on Monday.

Yes, this fixed my warnings. Thanks!

-- 
Kalle Valo
