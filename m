Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdKKOOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 09:14:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2017-11-11
References: <87o9o9vugd.fsf@kamboji.qca.qualcomm.com>
        <20171111.223832.2216321055833169803.davem@davemloft.net>
Date: Sat, 11 Nov 2017 16:14:06 +0200
In-Reply-To: <20171111.223832.2216321055833169803.davem@davemloft.net> (David
        Miller's message of "Sat, 11 Nov 2017 22:38:32 +0900 (KST)")
Message-ID: <87bmk89a35.fsf@codeaurora.org> (sfid-20171111_151432_128828_891A6A14)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Sat, 11 Nov 2017 15:03:14 +0200
>
>> some more patches to net-next for v4.15. Even though I applied the last
>> patch only on Saturday morning, all these have been tested by kbuild bot
>> and most of them should also be in linux-next. Please let me know if
>> there are any problems.
>
> Pulled, but looking at your merge commit message:

Thanks!

>> Major changes:
>> 
>> iwlwifi
>> 
>> * some new PCI IDs
>
> I doubt this was the only major change in here :-)))

Yeah, you're right. I wrote that too hastily. My excuse this time is
that I tagged it at the airport :) But of course I should have prepared
it better.

-- 
Kalle Valo
