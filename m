Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2E2Gtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 02:49:36 -0400
Message-ID: <1338274179.4342.6.camel@jlt3.sipsolutions.net> (sfid-20120529_084942_464161_EAA1E33E)
Subject: Re: Kernel splats in 3.3.6+, drv_finish_tx_sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 29 May 2012 08:49:39 +0200
In-Reply-To: <4FBD102A.3060906@candelatech.com> (sfid-20120523_182831_867959_52B63B9C)
References: <4FBD102A.3060906@candelatech.com>
	 (sfid-20120523_182831_867959_52B63B9C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-23 at 09:28 -0700, Ben Greear wrote:
> NOTE:  These are against 3.3.6+, not 3.3.7+ as I posted earlier.
> 
> We ran a torture test where we try to associate 130 stations against an AP
> that can only do 128.  The end result is constant resetting of many of the
> virtual station interfaces.
> 
> It ran overnight w/out crashing, but spewed quite a few warnings.
> 
> I will be happy to test patches or attempt fixes if anyone has suggestions
> for what the cause might be....
> 
> ------------[ cut here ]------------
> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:12 drv_finish_tx_sync+0x45/0x6e [mac80211]()
> Hardware name: To be filled by O.E.M.
> sta20:  Failed check-sdata-in-driver check, flags: 0x4

Somebody fixed this I believe (either Arik or Eliad I think)

johannes

