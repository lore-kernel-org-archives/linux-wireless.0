Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:16261 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753581Ab0LBHXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 02:23:43 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0905014620
	for <linux-wireless@vger.kernel.org>; Thu,  2 Dec 2010 16:23:41 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
Date: Thu, 2 Dec 2010 16:23:05 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6> <1291186468.4199.6.camel@jlt3.sipsolutions.net> <1291193337.4199.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291193337.4199.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012021623.05381.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed December 1 2010 17:48:57 Johannes Berg wrote:
> On Wed, 2010-12-01 at 07:54 +0100, Johannes Berg wrote:
> > On Wed, 2010-12-01 at 15:47 +0900, Bruno Randolf wrote:
> > > Already merged.
> > > 
> > > git show 79b1c460a0b55e55981c25c56597c4d5d2872de3
> > 
> > Oops, sorry -- was on iwlwifi tree which didn't merge yet and got
> > confused thinking it was mac80211 only.
> 
> Actually, I take that back. The patch *was* for mac80211 even though it
> claimed to be for cfg80211, and you still need to do the cfg80211
> versions.

Oh, sorry! So many interfaces... ;)
Patch on the way...

bruno
