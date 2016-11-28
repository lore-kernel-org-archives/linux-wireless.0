Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752772AbcK1B1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2016 20:27:37 -0500
Date: Sun, 27 Nov 2016 20:27:35 -0500 (EST)
Message-Id: <20161127.202735.878321128703384587.davem@davemloft.net> (sfid-20161128_022741_089900_CC532D8E)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-11-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <8760nbaoey.fsf@kamboji.qca.qualcomm.com>
References: <8760nbaoey.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 25 Nov 2016 11:39:49 +0200

> here's a pull request for 4.10. ath9k has now been converted to use
> mac80211 intermediate software queues to fix bufferbloat problems. rsi
> has become active again and latevy mwifiex has been getting a _lot_ of
> love.
> 
> I'm not expecting to see any problems with this pull request. When you
> pull git will do lots of automerging but at least I didn't see any
> conflicts. Please let me know if you have any problems.

Pulled, thanks Kalle.
