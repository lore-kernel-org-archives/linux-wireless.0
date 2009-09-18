Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48359 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZIRQWe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 12:22:34 -0400
Subject: Re: [PATCH] iwlwifi: drop lib80211 dependency
From: reinette chatre <reinette.chatre@intel.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <200909181820.04078.chunkeey@googlemail.com>
References: <200909181820.04078.chunkeey@googlemail.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 09:22:37 -0700
Message-Id: <1253290957.26521.625.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-09-18 at 09:20 -0700, Christian Lamparter wrote:
> Ever since Johannes' "iwlwifi: improve scan support" iwlwifi
> no longer needs any of lib80211's functions or definitions.
> 
> This patch updates iwlwifi's Kconfig _selections_ and
> removes all left lib80211.h inclusions from the source files.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you very much

Reinette


