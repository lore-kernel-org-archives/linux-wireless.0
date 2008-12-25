Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36503 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYLYAI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 19:08:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43/ssb: Add SPROM8 extraction and LP-PHY detection
Date: Thu, 25 Dec 2008 01:07:55 +0100
Cc: linville@tuxdriver.com, Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200812250039.28824.mb@bu3sch.de> <1230162724.3162.3.camel@johannes>
In-Reply-To: <1230162724.3162.3.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812250107.55584.mb@bu3sch.de> (sfid-20081225_010833_178093_A5A2E113)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 25 December 2008 00:52:04 Johannes Berg wrote:
> On Thu, 2008-12-25 at 00:39 +0100, Michael Buesch wrote:
> > This adds detection code for the LP-PHY and SPROM
> > extraction code for version 8, which is needed by the LP-PHY and
> > newer N-PHY.
> 
> I still get mac address ff:ff:ff:ff:ff:ff with this, but it might just
> be that we need to use a different address or something, will double
> check. We can fix that, so don't take this as a nack, the patch lays the
> foundation, and the devices aren't supported anyway.

Yep, this patch doesn't break anything that currently works.
So we can fix this later with another patch.

-- 
Greetings, Michael.
