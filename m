Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1IGMYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:38 -0400
Subject: Re: [RFC v2 1/5] nl80211/cfg80211: adding 'scan_cancel' command.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E6736CE.20004@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-2-git-send-email-VictorG@ti.com>
	 <1315224343.4075.7.camel@jlt3.sipsolutions.net>  <4E6736CE.20004@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 11:26:17 +0200
Message-ID: <1315387578.4002.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 12:18 +0300, Victor Goldenshtein wrote:
> On 05/09/2011 15:05, Johannes Berg wrote:
> > Would be nice to advertise availability, possibly through mac80211?
> >
> > johannes
> >
> 
> I can add new "IEEE80211_HW_SUPPORTS_CANCEL_SCAN" flag in the enum 
> ieee80211_hw_flags, if it's OK?

Yeah, also need to use that flag then and advertise the nl80211 command
if it is set, look for CMD() in nl80211.c

johannes

