Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbYICDhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:37:14 -0400
Date: Tue, 02 Sep 2008 20:37:07 -0700 (PDT)
Message-Id: <20080902.203707.83881587.davem@davemloft.net> (sfid-20080903_053717_202483_E482B7E8)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ron.rindjunsky@intel.com, tomas.winkler@intel.com
Subject: Re: [PATCH 5/9] iwlwifi: fix station mimo power save values
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-6-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-5-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-6-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:46 +0800

> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> 
> This patch fixes the wrong use MIMO power save values. Our TX was
> configured with our MIMO power save values instead of peer's MIMO power
> save values, this may affect connectivity. The peer STA/AP may not sense
> our traffic at all as it doesn't have all RX chains opened.
> 
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
