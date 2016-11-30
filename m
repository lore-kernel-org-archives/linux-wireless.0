Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:40586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753419AbcK3Teq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 14:34:46 -0500
Date: Wed, 30 Nov 2016 14:34:44 -0500 (EST)
Message-Id: <20161130.143444.242053190479060640.davem@davemloft.net> (sfid-20161130_203452_206474_814B3BA2)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2016-11-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <87r35utjq7.fsf@kamboji.qca.qualcomm.com>
References: <87r35utjq7.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 29 Nov 2016 16:59:44 +0200

> if there's still time here's one more patch to 3.9. I think this is good
> to have in 3.9 as it fixes an issue where we were printing uninitialised
> memory in mwifiex. I had this in wireless-drivers already for some time
> as I was waiting for other fixes and nothing serious actually came up.
> 
> If this doesn't make it to 3.9 that's not a problem, I'll just merge
> this to wireless-drivers-next. Let me know what you prefer.

Unless you are in a time-machine of some sort I assume you mean "4.9" not
"3.9" :-)

Pulled, thanks.
