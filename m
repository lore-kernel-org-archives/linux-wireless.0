Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753566AbdBUTt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 14:49:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jikos@kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: ath10k regression on XPS13
References: <87d1eb99dq.fsf_-_@purkki.adurom.net>
        <20170221.131858.949421414784612398.davem@davemloft.net>
        <87y3wzbd8n.fsf@kamboji.qca.qualcomm.com>
        <20170221.135337.291678413491553794.davem@davemloft.net>
Date: Tue, 21 Feb 2017 21:49:09 +0200
In-Reply-To: <20170221.135337.291678413491553794.davem@davemloft.net> (David
        Miller's message of "Tue, 21 Feb 2017 13:53:37 -0500 (EST)")
Message-ID: <87poibb9ze.fsf@kamboji.qca.qualcomm.com> (sfid-20170221_204931_063113_6DC7841A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Tue, 21 Feb 2017 20:38:48 +0200
>
>> David Miller <davem@davemloft.net> writes:
>> 
>>> From: Kalle Valo <kvalo@codeaurora.org>
>>> Date: Tue, 21 Feb 2017 11:32:49 +0200
>>>
>>>> We are working on a fix so that ath10k continues to work with older
>>>> board-2.bin, but that might take a day or two still.
>>>
>>> Kalle I really wanted to send my net-next pull request to Linus later
>>> today.  But I guess I have to wait for this ath10k first.
>>>
>>> Please get this to me as soon as possible, thanks.
>> 
>> We have a fix now but it's not really tested that well so I'm reluctant
>> to submit it yet. As I don't want to make you wait I think I'll submit
>> you a patch reverting f2593cb1b291 in an hour or two. And later in the
>> week I send you a properly fixed (and tested) version of f2593cb1b291.
>> 
>> Does that sound ok to you?
>
> Sure.

Here's the revert:

https://patchwork.ozlabs.org/patch/730735/

I didn't send a pull request because that felt overkill to do just for
one patch.

-- 
Kalle Valo
