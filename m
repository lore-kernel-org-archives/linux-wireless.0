Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab1DAK6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:58:42 -0400
Subject: Re: hostapd & mac80211: too many probe responses
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201104011255.59751.helmut.schaa@googlemail.com>
References: <201104011237.21983.helmut.schaa@googlemail.com>
	 <1301654802.3832.17.camel@jlt3.sipsolutions.net>
	 <201104011255.59751.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 13:00:34 +0200
Message-ID: <1301655634.3832.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 12:55 +0200, Helmut Schaa wrote:

> > Looks like we broke that then, IEEE80211_RX_CMNTR was intended to do
> > this. 
> 
> Ah, I see. I'll do some more debugging in that direction first ...

I think the 'rx->flags = 0;' thing is just wrong.

johannes

