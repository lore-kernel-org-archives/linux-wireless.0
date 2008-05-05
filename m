Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYEEIHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 04:07:00 -0400
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1209971503.3655.0.camel@johannes.berg>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 (sfid-20080505_044417_821018_3824BECA)  <1209971503.3655.0.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 05 May 2008 16:05:39 +0800
Message-Id: <1209974740.2827.124.camel@debian.sh.intel.com> (sfid-20080505_100623_025489_B35FBA76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-05 at 09:11 +0200, Johannes Berg wrote:
> Those conditions will never be true. 

Why? I see mac80211 never passes IEEE80211_IF_TYPE_MNTR to
add_interface(). But this patch passes the flag in configure_filter().
Please take a look.

> In the case of the latter, that is
> a good thing, in the case of the former that isn't.

Could you elaborate?

Thanks,
-yi

