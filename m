Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38051 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbKZQrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 11:47:00 -0500
Message-ID: <1448556415.2167.22.camel@sipsolutions.net> (sfid-20151126_174704_152395_B60FBD49)
Subject: Re: [PATCH v2 2/8] cfg80211: Remove unused
 cfg80211_can_use_iftype_chan()
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Thu, 26 Nov 2015 17:46:55 +0100
In-Reply-To: <1448303241-27747-3-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192818_058797_3713F391)
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-3-git-send-email-sojkam1@fel.cvut.cz>
	 (sfid-20151123_192818_058797_3713F391)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
> Last caller of this function was removed in 3.17 in commit
> 97dc94f1d933c9df2c0b327066ea130c0e92083f.
> 
Heh.

I've applied the first two patches for now - will review the others in
more detail later.

johannes
