Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2234 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761048AbXHWVO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 17:14:29 -0400
Date: Thu, 23 Aug 2007 16:51:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  b43legacy: Initial port of new driver with bcm43xx  PHY code and ssb/mac80211 front end
Message-ID: <20070823205141.GG2989@tuxdriver.com>
References: <46CC755A.5030109@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46CC755A.5030109@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2007 at 12:41:46PM -0500, Larry Finger wrote:

> This patch ports the PHY and radio handling code of the softmac driver
> to the mac80211 front end from b43. The resulting driver is known as
> b43legacy.

I have added this to the b43 branch of wireless-dev.  It is available
in 'everything' as well.

-- 
John W. Linville
linville@tuxdriver.com
