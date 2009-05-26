Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45878
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbZEZFmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 01:42:05 -0400
Date: Mon, 25 May 2009 22:42:04 -0700 (PDT)
Message-Id: <20090525.224204.118309389.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] iwmc3200wifi: fix link error when CFG80211 is not
 selected
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243307448-17441-3-git-send-email-yi.zhu@intel.com>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	<1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	<1243307448-17441-3-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Tue, 26 May 2009 11:10:48 +0800

> The patch makes iwmc3200wifi select CFG80211 instead of LIB80211.
> This fixed module link error reported by Randy Dunlap
> <randy.dunlap@oracle.com> when compiling iwmc3200wifi without
> cfg80211 selected. WIRELESS_EXT is also selected by iwmc3200wifi.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

I'm applying this directly so that the -next build failure
gets fixed.
