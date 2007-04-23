Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50156 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161260AbXDWS31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:29:27 -0400
Date: Mon, 23 Apr 2007 20:29:30 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: update for cfg80211 rtnl locking
Message-ID: <20070423202930.27749d11@griffin.suse.cz>
In-Reply-To: <1177147293.5941.2.camel@johannes.berg>
References: <1177147293.5941.2.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 21 Apr 2007 11:21:32 +0200, Johannes Berg wrote:
> cfg80211 was changed to hold the rtnl lock over calls to stack
> specific operations. This patch changes mac80211 to account for that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Jiri Benc <jbenc@suse.cz>

John, please apply with the cfg80211 rtnl patch.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
