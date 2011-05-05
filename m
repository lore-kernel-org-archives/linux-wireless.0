Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1EEOzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 10:55:55 -0400
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for
 scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <4DC2B941.6@candelatech.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-4-git-send-email-coelho@ti.com>
	 <4DC2B78E.3000205@candelatech.com>
	 <1304607108.3594.6.camel@jlt3.sipsolutions.net>
	 <4DC2B941.6@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 16:58:20 +0200
Message-ID: <1304607500.3594.7.camel@jlt3.sipsolutions.net> (sfid-20110505_165557_965402_0D829BAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 07:50 -0700, Ben Greear wrote:
> On 05/05/2011 07:51 AM, Johannes Berg wrote:
> > On Thu, 2011-05-05 at 07:43 -0700, Ben Greear wrote:
> >> On 05/05/2011 06:00 AM, Luciano Coelho wrote:
> >>> Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
> >>> NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
> >>> intervals the scheduled scan cycles should be executed.
> >>
> >> Please default to something useful instead of requiring
> >> this so that things are backwards compatible.
> >
> > Backward compatible to what?
> 
> To anything sending older style netlink messages?

But this is a new feature, and a new command, so I don't quite
understand why an application would think it can send it without the
interval?

johannes

