Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:55031 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbZHUUt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:49:27 -0400
Subject: Re: [PATCH v2] iwlwifi: Make injection of non-broadcast frames
 work again
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8EEAF9.6020308@gmail.com>
References: <4A8EEAF9.6020308@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Aug 2009 13:49:27 -0700
Message-Id: <1250887767.30019.14483.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-21 at 11:44 -0700, Gábor Stefanik wrote:
> Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
> ("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
> broke injection of non-broadcast frames to unassociated stations
> (causing a SYSASSERT for all such injected frames), due to injected
> frames no longer automatically getting a broadcast station ID assigned.
> This patch restores the old behavior, fixing the aforementioned
> regression.
> 
> Also, consistently check for IEEE80211_TX_CTL_INJECTED instead of
> iwl_is_monitor_mode in the TX path, as TX_CTL_INJECTED specifically
> means that a given packet is coming from a monitor interface, while
> iwl_is_monitor_mode only shows whether a monitor interface exists
> on the device.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette


