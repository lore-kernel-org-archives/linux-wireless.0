Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbYLIABZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 19:01:25 -0500
Subject: Re: [PATCH] iwlwifi: cleanup (remove pm_state)
From: reinette chatre <reinette.chatre@intel.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <eb3ff54b0812050816i5ee503b6o6c107ace966b204c@mail.gmail.com>
References: <eb3ff54b0812050816i5ee503b6o6c107ace966b204c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 16:02:26 -0800
Message-Id: <1228780946.8341.17.camel@rc-desk> (sfid-20081209_010131_117898_85F45CBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-05 at 08:16 -0800, Rami Rosen wrote:
> This patches removes unused variable (pm_state) from iwl-dev.h and
> from iwl-3945.h. (wireless-testing tree)
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
> b/drivers/net/wireless/iwlwifi/iwl-3945.h
> index 5c2c15e..b7f31d6 100644

Thank you.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


