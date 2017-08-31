Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdHaT0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 15:26:46 -0400
Date: Thu, 31 Aug 2017 12:26:45 -0700 (PDT)
Message-Id: <20170831.122645.872320547726000124.davem@davemloft.net> (sfid-20170831_212707_146057_42500479)
To: pavel@ucw.cz
Cc: kvalo@codeaurora.org, torvalds@linux-foundation.org,
        xiyou.wangcong@gmail.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: add a missing spin_lock_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170831185718.GA31245@amd>
References: <20170831144743.GA21261@amd>
        <20170831.103305.1809212990680774811.davem@davemloft.net>
        <20170831185718.GA31245@amd>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>
Date: Thu, 31 Aug 2017 20:57:19 +0200

> Hi!
> 
>> From: Pavel Machek <pavel@ucw.cz>
>> Date: Thu, 31 Aug 2017 16:47:43 +0200
>> 
>> > Dave, Linus -- can you still take the patch?
>> 
>> Pavel, please do not bypass maintainers like this.
>> 
>> It's really rude, and if you do things like that instead of
>> trying to work properly with us, your relationship with
>> these maintainers will suffer in the long term.
> 
> Do you mean I'm being rude to Kalle, or rude to you?

He said "to David", not "David and Linus".
