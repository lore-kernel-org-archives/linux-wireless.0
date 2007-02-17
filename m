Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:34345 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946477AbXBQIGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 03:06:17 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIKYv-0005Ff-0W
	for linux-wireless@vger.kernel.org; Sat, 17 Feb 2007 03:04:53 -0500
Subject: Re: More breakage in wireless-dev.git
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: Bcm43xx-dev@lists.berlios.de
In-Reply-To: <1171690868.31103.17.camel@dv>
References: <1171690868.31103.17.camel@dv>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 03:06:14 -0500
Message-Id: <1171699574.32411.6.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-02-17 at 00:41 -0500, Pavel Roskin wrote:

> There are more problems with today's wireless-dev.git even after I
> applied the two Johannes' patches.

Fixed in "d80211: fix incorrect hw.priv setting in ieee80211_alloc_hw()"
posted in linux-wireless.  In the meantime, just remove the second
assignment for local->hw.priv in ieee80211_alloc_hw().

I'm still getting "bcm43xx_d80211: FOUND UNSUPPORTED PHY (Analog 4, Type
0, Revision 7)" from bcm43xx_d80211 for a card that used to work.  That
must be a separate problem.

-- 
Regards,
Pavel Roskin

