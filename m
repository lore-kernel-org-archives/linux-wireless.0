Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55626
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbYICDjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:39:33 -0400
Date: Tue, 02 Sep 2008 20:39:26 -0700 (PDT)
Message-Id: <20080902.203926.165356802.davem@davemloft.net> (sfid-20080903_053936_425165_2665344B)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	gregory.greenman@intel.com, mohamed.abbas@intel.com,
	tomas.winkler@intel.com
Subject: Re: [PATCH 9/9] iwlwifi: fix STATUS_EXIT_PENDING is not set on
 pci_remove
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-10-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-8-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-9-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-10-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:50 +0800

> From: Gregory Greenman <gregory.greenman@intel.com>
> 
> This patch sets STATUS_EXIT_PENDING on pci_remove. Otherwise
> iwl4965_down may fail to uninitialize the driver.
> 
> Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
