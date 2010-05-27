Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0E0ILT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 04:11:19 -0400
Subject: Re: [PATCH] mac80211: mark 1, 2, 5.5 and 11Mbps as mandatory rates
 for 802.11b
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, juuso.oikarinen@nokia.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1274947716.3669.13.camel@jlt3.sipsolutions.net>
References: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
	 <20100527004545.11541.88667.stgit@tt-desk>
	 <1274947716.3669.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:11:11 +0200
Message-ID: <1274947871.3669.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 10:08 +0200, Johannes Berg wrote:
> On Thu, 2010-05-27 at 09:45 +0900, Bruno Randolf wrote:
> > IEEE802.11-2007 clause 18.2.3.3 (p640) states that 1, 2, 5.5 & 11 Mbits are
> > mandatory rates for what they call High Rate direct sequence spread spectrum
> > (HR/DSSS) PHY (with long PLCP).
> 
> You're confused. Clause 18 is 11g, we knew that those were mandatory
> there, see the code you're modifying.
> 
> Clause 15 is 11b, and it shouldn't change.

No wait, I'm confused. Clause 19 is 11g, and Clause 18 is 11b. But
what's Clause 15? Huh now I need to look back at this in more detail.

johannes

