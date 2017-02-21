Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdBUVBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 16:01:04 -0500
Date: Tue, 21 Feb 2017 16:01:03 -0500 (EST)
Message-Id: <20170221.160103.272609294929297575.davem@davemloft.net> (sfid-20170221_220108_226237_2A71AB03)
To: torvalds@linux-foundation.org
Cc: kvalo@codeaurora.org, jikos@kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: ath10k regression on XPS13
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFyqH3WAKsD_AaCe905zJbPzTXGygu2eiD1L0d6c2sAkGA@mail.gmail.com>
References: <87d1eb99dq.fsf_-_@purkki.adurom.net>
        <20170221.131858.949421414784612398.davem@davemloft.net>
        <CA+55aFyqH3WAKsD_AaCe905zJbPzTXGygu2eiD1L0d6c2sAkGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2017 10:52:33 -0800

> On Tue, Feb 21, 2017 at 10:18 AM, David Miller <davem@davemloft.net> wrote:
>>
>> Kalle I really wanted to send my net-next pull request to Linus later
>> today.  But I guess I have to wait for this ath10k first.
> 
> Feel free to send it to me - it sounds like the regression is
>  (a) easy to work around
> and
>  (b) has a fix coming up.
> 
> And it won't even be something that I personally notice, since I have
> the prev-gen XPS13 that has intel wireless.

I have the revert in my tree, it's all good.

I'll let my tree sit quietly for a few hours then send a pull
request out later tonight.
