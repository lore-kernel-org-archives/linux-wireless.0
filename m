Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:59791 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0FGVeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 17:34:23 -0400
Subject: Re: [PATCH] iwlwifi: add missing rcu_read_lock
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Miles Lane <miles.lane@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
References: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 14:34:22 -0700
Message-ID: <1275946462.1835.9324.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 12:20 -0700, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Using ieee80211_find_sta() needs to be under
> RCU read lock, which iwlwifi currently misses,
> so fix it.
> 
> Cc: stable@kernel.org
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


