Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50067 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161255AbXDWSZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:25:27 -0400
Date: Mon, 23 Apr 2007 20:25:31 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Sort supported rates in scan output
Message-ID: <20070423202531.678b2136@griffin.suse.cz>
In-Reply-To: <46284d71.8kVOR3LhjxSoo7lb%Larry.Finger@lwfinger.net>
References: <46284d71.8kVOR3LhjxSoo7lb%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 Apr 2007 00:19:45 -0500, Larry Finger wrote:
> In mac80211, the results of a scan show basic rates followed by
> extended rates, thus values are not listed in any particular order.
> This patch sorts all rates in increasing value.

Doesn't sound like a job for the kernel. I'd suggest sending a patch
for iwlist instead.

 Jiri

-- 
Jiri Benc
SUSE Labs
