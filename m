Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43373
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755311AbYICDhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:37:39 -0400
Date: Tue, 02 Sep 2008 20:37:32 -0700 (PDT)
Message-Id: <20080902.203732.01926986.davem@davemloft.net> (sfid-20080903_053741_685505_0A2D93E7)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, mohamed.abbas@intel.com
Subject: Re: [PATCH 6/9] iwlwifi: fix rx_chain computation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-7-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-6-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-7-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:47 +0800

> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch fixes rx_chain computation. The code that adjusts number of
> rx chains to number supported by HW was missing. Miss configuration
> causes firmware error.  Note: iwlwifi supports HW with up to 3 RX
> chains (2x2, 2x3, 1x2, and 3x3 MIMO). This patch also simplifies the
> whole RX chain computation.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
