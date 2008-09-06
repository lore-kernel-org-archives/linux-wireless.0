Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39914 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbYIFSlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:41:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
Date: Sat, 6 Sep 2008 20:41:05 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>
In-Reply-To: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200809062041.06035.mb@bu3sch.de> (sfid-20080906_204149_605477_EAD0EDFF)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 20:34:02 Larry Finger wrote:
> A coding error present since b43legacy was incorporated into the
> kernel has prevented the driver from using the rate-setting mechanism
> of mac80211. The driver has been forced to remain at a 1 Mb/s rate.

Does version3 firmware have a different bitlayout for the status?

> Although this is not strictly a regression, it is a bug. I hope
> it can be sent to 2.6.27.

The new rules don't allow us to fix bugs after the merge window.
Only regressions.

-- 
Greetings Michael.
