Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab1GNOq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 10:46:59 -0400
Subject: Re: [PATCH] mac80211: be more careful in suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4E1F005A.20808@hauke-m.de>
References: <1310653466.3874.23.camel@jlt3.sipsolutions.net>
	 <4E1F005A.20808@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 16:46:55 +0200
Message-ID: <1310654815.3874.24.camel@jlt3.sipsolutions.net> (sfid-20110714_164702_873523_54489739)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 16:42 +0200, Hauke Mehrtens wrote:

> > +	/* reset coverage class */
> > +	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
> 
> Shouldn't this be
> drv_set_coverage_class(local, hw->wiphy->coverage_class);

Err, of course, good catch. Thanks!

johannes

