Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZA1VW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 16:22:56 -0500
Subject: Re: [PATCH v2.6.29] iwlwifi: clean key table in
	iwl_clear_stations_table
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1233169537.16048.4.camel@johannes.local>
References: <> <1233164310-22770-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090128_183539_794013_573635C8)  <1233169537.16048.4.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 13:25:44 -0800
Message-Id: <1233177944.22831.10.camel@rc-desk> (sfid-20090128_222300_431487_76EFF14F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-28 at 11:05 -0800, Johannes Berg wrote:
> On Wed, 2009-01-28 at 09:38 -0800, Reinette Chatre wrote:
> > Cleans uCode key table bit map iwl_clear_stations_table
> > since all stations are cleared also the key table must be.
> > 
> > Since the keys are not removed properly on suspend by mac80211
> > this may result in exhausting key table on resume leading
> > to memory corruption during removal
> 
> Just FYI, this is fixed now in mac80211.

Sorry - I missed this. Could you please point me to the patch? 
The problem was encountered in 2.6.29-rc2 (see
http://bugzilla.kernel.org/show_bug.cgi?id=12415 ) and I would like to
know if this patch you refer to is included there. If so then we have
another issue.

Thanks

Reinette


