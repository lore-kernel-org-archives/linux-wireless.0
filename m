Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55489 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbKCJn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:43:58 -0500
Message-ID: <1446543835.29010.11.camel@sipsolutions.net> (sfid-20151103_104823_365845_9CDC2881)
Subject: Re: [PATCH] mac80211: fix crash on mesh local link ID generation
 with VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Schiffer <mschiffer@universe-factory.net>,
	linux-wireless@vger.kernel.org
Date: Tue, 03 Nov 2015 10:43:55 +0100
In-Reply-To: <410200d1bd404c5c3acf66b8cabaae2860df2241.1445714370.git.mschiffer@universe-factory.net>
References: <410200d1bd404c5c3acf66b8cabaae2860df2241.1445714370.git.mschiffer@universe-factory.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-10-24 at 21:25 +0200, Matthias Schiffer wrote:
> llid_in_use needs to be limited to stations of the same VIF, 
> otherwise it
> will cause a NULL deref as the sta_info of non-mesh-VIFs don't have
> sta->mesh set.
> 
Applied, thanks.

johannes
