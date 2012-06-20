Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2FTJNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:13:10 -0400
Message-ID: <1340183587.4655.55.camel@jlt3.sipsolutions.net> (sfid-20120620_111313_960687_587362D7)
Subject: Re: [RFCv2 05/13] cfg80211: introduce cfg80211_get_chan_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jun 2012 11:13:07 +0200
In-Reply-To: <4FE193B2.6020000@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	  <1340172859-18146-6-git-send-email-michal.kazior@tieto.com>
	 <1340180381.4655.25.camel@jlt3.sipsolutions.net>
	 <4FE193B2.6020000@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:11 +0200, Michal Kazior wrote:

> >> +void
> >> +cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
> >> +		        struct wireless_dev *wdev,
> >> +		        struct ieee80211_channel **chan,
> >> +		        enum cfg80211_chan_mode *chanmode)
> >
> > Why not return the mode rather than void&  pointer?
> 
> I think returning the mode would be ambiguous - the function name isn't 
> "get_chan_mode". chan_mode isn't a result on its own. But then again, 
> it's just a matter of preference.

No, ok, you're right -- I missed that it was returning both the channel
& the mode.

johannes

