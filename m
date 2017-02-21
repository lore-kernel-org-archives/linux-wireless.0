Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbdBUSjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 13:39:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jikos@kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: ath10k regression on XPS13
References: <alpine.LSU.2.20.1702201508280.24579@cbobk.fhfr.pm>
        <CA+55aFxLmgA7drrGfUJmCRPT-A74ROYf6GQHFGO5pzVjZ0dL7Q@mail.gmail.com>
        <87d1eb99dq.fsf_-_@purkki.adurom.net>
        <20170221.131858.949421414784612398.davem@davemloft.net>
Date: Tue, 21 Feb 2017 20:38:48 +0200
In-Reply-To: <20170221.131858.949421414784612398.davem@davemloft.net> (David
        Miller's message of "Tue, 21 Feb 2017 13:18:58 -0500 (EST)")
Message-ID: <87y3wzbd8n.fsf@kamboji.qca.qualcomm.com> (sfid-20170221_193951_294567_AD9236F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Tue, 21 Feb 2017 11:32:49 +0200
>
>> We are working on a fix so that ath10k continues to work with older
>> board-2.bin, but that might take a day or two still.
>
> Kalle I really wanted to send my net-next pull request to Linus later
> today.  But I guess I have to wait for this ath10k first.
>
> Please get this to me as soon as possible, thanks.

We have a fix now but it's not really tested that well so I'm reluctant
to submit it yet. As I don't want to make you wait I think I'll submit
you a patch reverting f2593cb1b291 in an hour or two. And later in the
week I send you a properly fixed (and tested) version of f2593cb1b291.

Does that sound ok to you?

-- 
Kalle Valo
