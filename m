Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab0KSSsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 13:48:05 -0500
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1290192337.3768.6.camel@jlt3.sipsolutions.net>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
	 <1290192337.3768.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 10:49:38 -0800
Message-ID: <1290192578.3768.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 10:45 -0800, Johannes Berg wrote:
> You'll need to provide documentation updates for this ASAP.

I also expect a patch that adds discoverability of the availability of
these commands, using a flag through mac80211 so that the commands are
only discovered as available when the _driver_ implements them, not just
if _mac80211_ implements them. Also with checking that the flag is set
and rejecting them if not in the nl80211 functions.

johannes

