Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1IGMYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:36 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E6736D9.3070804@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net>  <4E6736D9.3070804@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 11:26:59 +0200
Message-ID: <1315387619.4002.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 12:18 +0300, Victor Goldenshtein wrote:
> On 05/09/2011 15:08, Johannes Berg wrote:
> 
> > Also, this feature needs to be discoverable somehow, I think?
> >
> > johannes
> >
> 
> The intermediate scan event is not HW dependent, so there is no need to 
> advertise it..

Not with mac80211 drivers, but with cfg80211 drivers?

johannes

