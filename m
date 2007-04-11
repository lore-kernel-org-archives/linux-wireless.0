Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49021
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXDKRXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 13:23:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev 1 PHYs
Date: Wed, 11 Apr 2007 19:22:26 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
In-Reply-To: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200704111922.27087.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 April 2007 18:08, Larry Finger wrote:
> On PPC architecture with phy->rev == 1, machine checks occur during
> initialization of the "Extended G PHY registers". This problem was
> also seen on bcm43xx-softmac, and was fixed by conditionally skipping
> over certain reads/writes of these registers.  The same solution has been
> applied here with testing by David Woodhouse.  Note: These modifications
> are not found in the specifications, but are needed for PPC.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John and Michael,
> 
> This patch will apply to both the wireless-dev and the mb trees.

Applied to my tree, thanks.
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=e25588a08a1b7e0d500c30dd0ccee76d318fe72d

-- 
Greetings Michael.
