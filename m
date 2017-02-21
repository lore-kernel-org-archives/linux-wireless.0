Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdBUSxk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 13:53:40 -0500
Date: Tue, 21 Feb 2017 13:53:37 -0500 (EST)
Message-Id: <20170221.135337.291678413491553794.davem@davemloft.net> (sfid-20170221_195711_477687_00156476)
To: kvalo@codeaurora.org
Cc: torvalds@linux-foundation.org, jikos@kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: ath10k regression on XPS13
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y3wzbd8n.fsf@kamboji.qca.qualcomm.com>
References: <87d1eb99dq.fsf_-_@purkki.adurom.net>
        <20170221.131858.949421414784612398.davem@davemloft.net>
        <87y3wzbd8n.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 21 Feb 2017 20:38:48 +0200

> David Miller <davem@davemloft.net> writes:
> 
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Tue, 21 Feb 2017 11:32:49 +0200
>>
>>> We are working on a fix so that ath10k continues to work with older
>>> board-2.bin, but that might take a day or two still.
>>
>> Kalle I really wanted to send my net-next pull request to Linus later
>> today.  But I guess I have to wait for this ath10k first.
>>
>> Please get this to me as soon as possible, thanks.
> 
> We have a fix now but it's not really tested that well so I'm reluctant
> to submit it yet. As I don't want to make you wait I think I'll submit
> you a patch reverting f2593cb1b291 in an hour or two. And later in the
> week I send you a properly fixed (and tested) version of f2593cb1b291.
> 
> Does that sound ok to you?

Sure.
