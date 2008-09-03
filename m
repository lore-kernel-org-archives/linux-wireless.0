Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43360
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbYICDff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:35:35 -0400
Date: Tue, 02 Sep 2008 20:35:28 -0700 (PDT)
Message-Id: <20080902.203528.185666587.davem@davemloft.net> (sfid-20080903_055043_531128_3B244FCB)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mohamed.abbas@intel.com, tomas.winkler@intel.com
Subject: Re: [PATCH 3/9] iwlwifi: remove false rxon if rx chain changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-4-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:44 +0800

> From: Mohamed Abbas <mohamed.abbas@intel.com>
> 
> Rx chain might change during power save transitions but it doesn't
> require sending Full-ROXN command to the firmware. Full-RXON requires
> reconnection to an AP and thus affects user experience. The patch
> avoids the Full-RXON by removing the rx_chain modification check in
> iwl_full_rxon_required function.
> 
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
