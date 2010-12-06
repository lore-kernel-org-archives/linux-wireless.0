Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:24727 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752438Ab0LFDr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 22:47:28 -0500
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0807857246
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 12:47:26 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
Date: Mon, 6 Dec 2010 12:47:24 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6> <1290192337.3768.6.camel@jlt3.sipsolutions.net> <1290192578.3768.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290192578.3768.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012061247.24886.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat November 20 2010 03:49:38 Johannes Berg wrote:
> On Fri, 2010-11-19 at 10:45 -0800, Johannes Berg wrote:
> > You'll need to provide documentation updates for this ASAP.
> 
> I also expect a patch that adds discoverability of the availability of
> these commands, using a flag through mac80211 so that the commands are
> only discovered as available when the _driver_ implements them, not just
> if _mac80211_ implements them. Also with checking that the flag is set
> and rejecting them if not in the nl80211 functions.

I just mailed a patch implementing this. I don't use a flag but a variable 
available_antennas in wiphy, just like with the number of queues. I hope this 
is what you had in mind.

bruno
