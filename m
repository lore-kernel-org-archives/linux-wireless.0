Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42008
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbXEaIYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2007 04:24:55 -0400
Date: Thu, 31 May 2007 01:25:08 -0700 (PDT)
Message-Id: <20070531.012508.18299215.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 fixes for 2.6.22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070530182538.GB3610@tuxdriver.com>
References: <20070530182538.GB3610@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 30 May 2007 14:25:38 -0400

> Some bug fixes that should be applied to 2.6.22:
> 
>       mac80211: fail back to use associate from reassociate
>       mac80211: fix memory leak when defrag fragments
>       mac80211: always set carrier status on open
>       mac80211: avoid null ptr deref in ieee80211_ibss_add_sta
> 
> These are also available in the wireless-2.6 git tree:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git mac80211
> 
> Please apply at your earliest convenience!

Looks good, pulled, thanks a lot John.
