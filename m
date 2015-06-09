Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54832 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbFITvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:51:50 -0400
Message-ID: <1433879507.1892.18.camel@sipsolutions.net> (sfid-20150609_215152_567519_4CE3F833)
Subject: Re: [PATCH] mac80211: release channel on auth failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Jun 2015 21:51:47 +0200
In-Reply-To: <1433313373-28216-1-git-send-email-michal.kazior@tieto.com> (sfid-20150603_083621_837851_819E36BF)
References: <1433313373-28216-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150603_083621_837851_819E36BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 08:36 +0200, Michal Kazior wrote:
> There were a few rare cases when upon
> authentication failure channel wasn't released.
> This could cause stale pointers to remain in
> chanctx assigned_vifs after interface removal and
> trigger general protection fault later.

Applied. I've put this on -next, but perhaps it's needed for stable too?
Maybe we can send it there next week or so ...

johannes

