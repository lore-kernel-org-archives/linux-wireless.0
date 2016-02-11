Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49720 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbcBKJ2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 04:28:13 -0500
Date: Thu, 11 Feb 2016 04:28:10 -0500 (EST)
Message-Id: <20160211.042810.974143616679450202.davem@davemloft.net> (sfid-20160211_102822_411640_D199B26C)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ja@ssi.bg,
	johannes.berg@intel.com
Subject: Re: [PATCH v3 4/4] ipv6: add option to drop unsolicited neighbor
 advertisements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1454589080-21354-4-git-send-email-johannes@sipsolutions.net>
References: <1454589080-21354-1-git-send-email-johannes@sipsolutions.net>
	<1454589080-21354-4-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu,  4 Feb 2016 13:31:20 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In certain 802.11 wireless deployments, there will be NA proxies
> that use knowledge of the network to correctly answer requests.
> To prevent unsolicitd advertisements on the shared medium from
> being a problem, on such deployments wireless needs to drop them.
> 
> Enable this by providing an option called "drop_unsolicited_na".
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.
