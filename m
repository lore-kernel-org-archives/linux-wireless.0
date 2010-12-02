Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0LBH2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 02:28:33 -0500
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <201012021623.05381.br1@einfach.org>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
	 <1291186468.4199.6.camel@jlt3.sipsolutions.net>
	 <1291193337.4199.7.camel@jlt3.sipsolutions.net>
	 <201012021623.05381.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 08:28:28 +0100
Message-ID: <1291274908.3481.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 16:23 +0900, Bruno Randolf wrote:
> On Wed December 1 2010 17:48:57 Johannes Berg wrote:
> > On Wed, 2010-12-01 at 07:54 +0100, Johannes Berg wrote:
> > > On Wed, 2010-12-01 at 15:47 +0900, Bruno Randolf wrote:
> > > > Already merged.
> > > > 
> > > > git show 79b1c460a0b55e55981c25c56597c4d5d2872de3
> > > 
> > > Oops, sorry -- was on iwlwifi tree which didn't merge yet and got
> > > confused thinking it was mac80211 only.
> > 
> > Actually, I take that back. The patch *was* for mac80211 even though it
> > claimed to be for cfg80211, and you still need to do the cfg80211
> > versions.
> 
> Oh, sorry! So many interfaces... ;)
> Patch on the way...

Thanks!

johannes

