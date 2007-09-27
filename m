Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2227 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbXI0VIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 17:08:44 -0400
Date: Thu, 27 Sep 2007 16:58:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: [patch 11/12] mac80211: remove management interface
Message-ID: <20070927205803.GF7991@tuxdriver.com>
References: <20070926131938.575572000@sipsolutions.net> <20070926132136.676468000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070926132136.676468000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please fixup this patch for at least the drivers already merged
to net-2.6.24.  Also, don't forget the Signed-off-by:...

Thanks,

John

On Wed, Sep 26, 2007 at 03:19:49PM +0200, Johannes Berg wrote:
> Similar to the previous patch
> 
> ---
>  include/net/mac80211.h          |    1 
>  net/mac80211/ieee80211.c        |  182 ----------------------------------------
>  net/mac80211/ieee80211_common.h |   91 --------------------
>  net/mac80211/ieee80211_i.h      |    9 -
>  net/mac80211/ieee80211_iface.c  |   66 --------------
>  net/mac80211/ieee80211_rate.c   |    3 
>  net/mac80211/ieee80211_rate.h   |    2 
>  net/mac80211/ieee80211_sta.c    |    2 
>  net/mac80211/rx.c               |   35 +------
>  net/mac80211/tx.c               |   14 ---
>  net/mac80211/wme.c              |   10 --
>  11 files changed, 14 insertions(+), 401 deletions(-)
-- 
John W. Linville
linville@tuxdriver.com
