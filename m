Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37751 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbcCDGle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 01:41:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	johannes@sipsolutions.net, netdev@vger.kernel.org,
	eric.dumazet@gmail.com, dave.taht@gmail.com,
	emmanuel.grumbach@intel.com, nbd@openwrt.org,
	andrewmcgr@google.com, apenwarr@google.com
Subject: Re: [PATCH RFC/RFT 1/2] ath9k: rename struct ath_txq to struct ath_hwq
References: <E1abeND-0007xj-00@www.xplot.org>
Date: Fri, 04 Mar 2016 08:41:28 +0200
In-Reply-To: <E1abeND-0007xj-00@www.xplot.org> (Tim Shepard's message of "Thu,
	03 Mar 2016 20:17:43 -0500")
Message-ID: <87vb52lp7r.fsf@purkki.adurom.net> (sfid-20160304_074158_766070_7CB3EF2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

> Also use hwq instead of txq to refer to it throughout ath9k/*.  This
> is prep work for using mac80211's new intermediate queues, which are
> called txq, and it would be too confusing if both are called txq.

You should add Signed-off-by to both patches in case someone else wants
to work with these.

-- 
Kalle Valo
