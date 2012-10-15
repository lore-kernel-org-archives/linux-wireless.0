Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2JOPXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 11:23:53 -0400
Message-ID: <1350314666.27801.9.camel@jlt4.sipsolutions.net> (sfid-20121015_172356_021395_E0E9E051)
Subject: Re: [PATCH] cfg80211/mac80211: avoid state mishmash on deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 17:24:26 +0200
In-Reply-To: <20121015125231.GA9941@redhat.com>
References: <20121015125231.GA9941@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-15 at 14:52 +0200, Stanislaw Gruszka wrote:
> Avoid situation when we are on associate state in mac80211 and
> on disassociate state in cfg80211. This can results on crash
> during modules unload (like showed on this thread:
> http://marc.info/?t=134373976300001&r=1&w=2) and possibly other
> problems.
> 
> Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Applied, thanks for debugging this!

johannes

