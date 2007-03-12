Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283AbXCLHyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 03:54:23 -0400
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net>
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 08:53:09 +0100
Message-Id: <1173685989.3584.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-03-02 at 11:30 -0600, Larry Finger wrote:
> There was an error in the B5PHY init specifications.

This patch doesn't fix the machine check in bcm43xx_phy_initb5 which
Pavel Roskin and I reported a couple of weeks ago. To get rid of that
crash, I still have to revert an earlier 'spec update' patch
(740ac4fb08866d702be90f167665d03759bd27d0).

-- 
dwmw2

