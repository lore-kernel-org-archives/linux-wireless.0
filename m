Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0E0MNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 08:13:50 -0400
Subject: Re: [PATCH] mac80211: mark 1, 2, 5.5 and 11Mbps as mandatory rates
 for 802.11b
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	juuso.oikarinen@nokia.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4BFE60EF.7020800@free.fr>
References: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
	 <20100527004545.11541.88667.stgit@tt-desk>
	 <1274947716.3669.13.camel@jlt3.sipsolutions.net> <4BFE60EF.7020800@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 14:13:40 +0200
Message-ID: <1274962420.3669.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 14:09 +0200, Benoit Papillault wrote:

> 802.11a = Clause 17, called OFDM
> 802.11b = Clause 15 (called DSSS) & Clause 18 (called HR/DSSS).

Are you sure? Isn't clause 15 pre-amendement?

> Clause 15 defines 1 Mbits and 2 Mbits rates, long PLCP only
> Clause 18 defines 5.5 Mbits and 11 Mbits. Optionally, short PLCP is 
> available for 2 Mbits, 5.5 Mbits and 11 Mbits. Since it's optional, such 
> short PLCP rates are probably not part of the mandatory rates.
> 
> Basic rate set must includes mandatory rates set. 

I don't think this is true.

> This is apparently 
> what every other AP do today and I indeed see no points in adding more 
> rates to the basic rate set other than what is already defined in the 
> mandatory rate set (except we cannot rely on this rule when joining an 
> existing BSS/IBSS, of course).

Sure, you can add more than say 11b mandatory rates to specifically
exclude non-11g stations from it to improve performance.

johannes

