Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61932 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZBNFvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:51:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:51:33 -0800
Date: Fri, 13 Feb 2009 21:50:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] cfg80211: move reg hints to workqueue
Message-ID: <20090214055049.GC5769@tesla> (sfid-20090214_065137_837572_B4C491D8)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 09:33:37PM -0800, Luis Rodriguez wrote:
> This series does prep work and then the actual work to move the
> cfg80211 driver and userspace regulatory hints onto a workqueue.
> This also cleans up the core reg hint onto its own routine which
> addresses some of Johannes comments about the branching on the
> assert_cfg80211_mutex(). We also now do a cleanup the comment
> style on reg.c.

I forgot to mention this is now rebased on top of Johannes' two
nl80211 patches:

nl80211: lock rtnl around all operations
genetlink: introduce pre/post methods

  Luis
