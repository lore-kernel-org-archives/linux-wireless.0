Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0LAItO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 03:49:14 -0500
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291186468.4199.6.camel@jlt3.sipsolutions.net>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
	 <201011241045.05708.br1@einfach.org>
	 <1291185817.4199.5.camel@jlt3.sipsolutions.net>
	 <201012011547.48339.br1@einfach.org>
	 <1291186468.4199.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:48:57 +0100
Message-ID: <1291193337.4199.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 07:54 +0100, Johannes Berg wrote:
> On Wed, 2010-12-01 at 15:47 +0900, Bruno Randolf wrote:
> 
> > Already merged.
> > 
> > git show 79b1c460a0b55e55981c25c56597c4d5d2872de3
> 
> Oops, sorry -- was on iwlwifi tree which didn't merge yet and got
> confused thinking it was mac80211 only.

Actually, I take that back. The patch *was* for mac80211 even though it
claimed to be for cfg80211, and you still need to do the cfg80211
versions.

johannes

