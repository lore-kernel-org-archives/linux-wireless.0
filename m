Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbcBKJ1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 04:27:54 -0500
Date: Thu, 11 Feb 2016 04:27:50 -0500 (EST)
Message-Id: <20160211.042750.376596563683727607.davem@davemloft.net> (sfid-20160211_102806_065709_ED10213A)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ja@ssi.bg,
	johannes.berg@intel.com
Subject: Re: [PATCH v3 1/4] ipv4: add option to drop unicast encapsulated
 in L2 multicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <1454589080-21354-1-git-send-email-johannes@sipsolutions.net>
References: <1454589080-21354-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu,  4 Feb 2016 13:31:17 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In order to solve a problem with 802.11, the so-called hole-196 attack,
> add an option (sysctl) called "drop_unicast_in_l2_multicast" which, if
> enabled, causes the stack to drop IPv4 unicast packets encapsulated in
> link-layer multi- or broadcast frames. Such frames can (as an attack)
> be created by any member of the same wireless network and transmitted
> as valid encrypted frames since the symmetric key for broadcast frames
> is shared between all stations.
> 
> Additionally, enabling this option provides compliance with a SHOULD
> clause of RFC 1122.
> 
> Reviewed-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.
