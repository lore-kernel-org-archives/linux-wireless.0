Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:35069 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXBGGef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 01:34:35 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HEgMv-00065l-0e
	for linux-wireless@vger.kernel.org; Wed, 07 Feb 2007 01:33:25 -0500
Subject: Re: RFT: The real fix for BCM4311 and BCM4312
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <45C96B8A.8010000@lwfinger.net>
References: <45C96B8A.8010000@lwfinger.net>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 01:34:31 -0500
Message-Id: <1170830071.11150.62.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-02-07 at 00:02 -0600, Larry Finger wrote:
> The patch below will only affect cards with PHY revision 8, which I think are only BCM4311 and
> BCM4312. At least those are the only ones in the database.

BCM4312, old patch: 1.7M/s
no patch: 26k/s
no patch, rate 1: 100k/s
new patch: 1.7M/s
new patch, rate 1: 1.1M/s
new patch, rate 2: 1.5M/s
new patch, rate 5.5: 1.7M/s
new patch, rate 18: 2.2M/s
new patch, rate 36: 2.2M/s

Yes, it looks like the new patch is as good as the previous one for my card.

The rates are reported by wget, so they are not nearly precise, but the
difference of 2 orders of magnitude just cannot be explained by anything
other than the fix to the driver.

-- 
Regards,
Pavel Roskin

