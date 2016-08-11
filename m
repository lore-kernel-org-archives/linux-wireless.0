Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52739 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbcHKMoV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:44:21 -0400
Message-ID: <1470919457.12075.5.camel@sipsolutions.net> (sfid-20160811_144425_306588_B8B28292)
Subject: Re: [PATCH v3 0/3] Improve wireless netdev detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 14:44:17 +0200
In-Reply-To: <1470261515-2830-1-git-send-email-denkenz@gmail.com> (sfid-20160803_161400_172995_F10633C5)
References: <1470261515-2830-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160803_161400_172995_F10633C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-03 at 16:58 -0500, Denis Kenzior wrote:
> The current mechanism to detect hot-plug / unplug of wireless devices
> is
> somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events
> over
> nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
> somehow find a correlation between these events.  This involves
> userspace
> sending GET_INTERFACE or GET_WIPHY commands to the kernel, which
> incurs
> additional roundtrips.
> 

Applied. I squashed 1/2 since it's kinda pointless to have a patch
introducing infrastructure that's not used.

I also made some minor cleanups - please check (both that it's right,
and for next time)

johannes
