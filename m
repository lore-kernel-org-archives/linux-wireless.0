Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13607 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbYJMR41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 13:56:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 10:56:27 -0700
Date: Mon, 13 Oct 2008 03:56:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath9k/mac80211: disallow fragmentation in ath9k,
	report to userspace
Message-ID: <20081013105619.GG5965@tesla> (sfid-20081013_195631_791132_F39F77D9)
References: <1223897706.24954.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1223897706.24954.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 04:35:05AM -0700, Johannes Berg wrote:
> As I've reported, ath9k currently fails utterly when fragmentation
> is enabled. This makes ath9k "support" hardware fragmentation by
> not supporting fragmentation at all to avoid the double-free issue.
> The patch also changes mac80211 to report errors from the driver
> operation to userspace.
> 
> That hack in ath9k should be removed once the rate control algorithm
> it has is fixed, and we can at that time consider removing the hw
> fragmentation support entirely since it's not used by any driver.

Thanks.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
