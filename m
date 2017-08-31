Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdHaRdH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 13:33:07 -0400
Date: Thu, 31 Aug 2017 10:33:05 -0700 (PDT)
Message-Id: <20170831.103305.1809212990680774811.davem@davemloft.net> (sfid-20170831_193323_517071_C7977C80)
To: pavel@ucw.cz
Cc: kvalo@codeaurora.org, torvalds@linux-foundation.org,
        xiyou.wangcong@gmail.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: add a missing spin_lock_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170831144743.GA21261@amd>
References: <20170831065204.GA17812@amd>
        <87y3q0q7ln.fsf@kamboji.qca.qualcomm.com>
        <20170831144743.GA21261@amd>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>
Date: Thu, 31 Aug 2017 16:47:43 +0200

> Dave, Linus -- can you still take the patch?

Pavel, please do not bypass maintainers like this.

It's really rude, and if you do things like that instead of
trying to work properly with us, your relationship with
these maintainers will suffer in the long term.

Thank you.
