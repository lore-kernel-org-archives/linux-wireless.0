Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbcCRQtY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 12:49:24 -0400
Message-ID: <1458319756.13729.1.camel@sipsolutions.net> (sfid-20160318_174943_542543_A1B3F7F6)
Subject: Re: [PATCH] mac80211: fix order of flag descriptions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Fri, 18 Mar 2016 17:49:16 +0100
In-Reply-To: <1458318955-32070-1-git-send-email-luisbg@osg.samsung.com>
References: <1458317369-28185-1-git-send-email-luisbg@osg.samsung.com>
	 <1458318955-32070-1-git-send-email-luisbg@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 16:35 +0000, Luis de Bethencourt wrote:
> Fix order of mac80211_rx_flags description to match the enum.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
> Hi,
> 
> I want ahead and fixed the order of the descriptions. checkpatch.pl
> was giving
> a warning to my previous patch and I had a hunch it was because the
> wrong order
> breaks the parser. Indeed it does and with this patch below
> checkpatch.pl does
> not complain about this flag descriptions anymore.
> 
Huh. I think we should fix checkpatch.pl instead. While the current
order isn't likely really good, I believe kernel-doc will output the
documentation in the order it's listed, and that can be useful for the
documentation output to group related things, even if their bits may be
further apart.

johannes
