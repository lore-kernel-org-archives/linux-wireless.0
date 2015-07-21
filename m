Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbGUHSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 03:18:23 -0400
Date: Tue, 21 Jul 2015 00:18:22 -0700 (PDT)
Message-Id: <20150721.001822.1980540939930930362.davem@davemloft.net> (sfid-20150721_091830_655606_57DC85BA)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2015-07-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <1437139894.1933.16.camel@sipsolutions.net>
References: <1437139894.1933.16.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 17 Jul 2015 15:31:34 +0200

> We've accumulated some wireless fixes, please pull. Arik's fix is a bit
> bigger than I might like, but it fixes a real locking issue and we
> didn't really see a good way to make a smaller version.
> 
> Let me know if there's any problem.

Pulled, thanks a lot Johannes.
