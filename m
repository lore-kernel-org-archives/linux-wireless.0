Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6249 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002AbZDTWoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 18:44:10 -0400
Subject: Re: [PATCH] mac80211: do not print WARN if config interface fails
 during reconfigure
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1240266828.17388.1.camel@johannes.local>
References: <1240266979-9254-1-git-send-email-reinette.chatre@intel.com>
	 <1240266828.17388.1.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 15:50:14 -0700
Message-Id: <1240267814.5206.113.camel@rc-desk> (sfid-20090421_004414_559714_38CBB0FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-04-20 at 15:33 -0700, Johannes Berg wrote:
> On Mon, 2009-04-20 at 15:36 -0700, Reinette Chatre wrote:
> > It is expected that config interface will always succeed as mac80211
> > will only request what driver supports. The exception here is when a
> > device has rfkill enabled. At this time the rfkill state is unknown to
> > mac80211 and config interface can fail. When this happens we deal with
> > this error instead of printing a WARN.
> 
> Thanks. Just to make sure -- this really is just papering over the
> warning, not actually fixing it. I hope we can fix it soon by making
> mac80211 aware of rfkill.

Yes it is ... I did this because kerneloops.org exists.

Reinette


