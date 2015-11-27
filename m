Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44723 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbK0I10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:27:26 -0500
Message-ID: <1448612842.2531.5.camel@sipsolutions.net> (sfid-20151127_092729_088251_277D9D6C)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Fri, 27 Nov 2015 09:27:22 +0100
In-Reply-To: <9d111cc7d61047b5890b7c5d53d71bbd@SC-EXCH02.marvell.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	 <1448018530.3141.25.camel@sipsolutions.net>
	 <097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
	 <1448530804.2167.4.camel@sipsolutions.net>
	 <9d111cc7d61047b5890b7c5d53d71bbd@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-27 at 02:00 +0000, David Lin wrote:
> > Ditto - you're allowed to modify mac80211. We actually have a patch
> > like this
> > already:
> > https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-
> > next.git/commit/?id=99e7ca44bb910f0cbfda5d9008e8517df0ebc939
> > 
> 
> Once if this patch is ready, I will modify mwlwifi to use it. Thanks.

The patch is ready now and in the tree, but that wasn't my point. My
point is that you shouldn't try to hack around mac80211 like with the
action frame interception and the mesh-amsdu-reimplementation, but
actually go fix it.

If you have issues with mac80211 like this you can ask how to fix them,
or just fix them and suggest changes/patches, but just working around
it in the driver isn't the right approach.

johannes
