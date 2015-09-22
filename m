Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52139 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585AbbIVNaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:30:12 -0400
Message-ID: <1442928605.2018.11.camel@sipsolutions.net> (sfid-20150922_153040_857397_C5D38FAB)
Subject: Re: [PATCH 0/6] mac80211: Deinline large functions in driver-ops.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Denys Vlasenko <dvlasenk@redhat.com>,
	John Linville <linville@tuxdriver.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2015 15:30:05 +0200
In-Reply-To: <1442928526.2018.10.camel@sipsolutions.net> (sfid-20150922_152920_167326_BEB334F9)
References: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com>
	 (sfid-20150918_152212_883153_32910567) <1442928526.2018.10.camel@sipsolutions.net>
	 (sfid-20150922_152920_167326_BEB334F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-22 at 15:28 +0200, Johannes Berg wrote:
> On Fri, 2015-09-18 at 15:19 +0200, Denys Vlasenko wrote:
> > After measuring size of inlines, these functions were found to be 
> > largest.
> > These patches reduce code size by about 21 kbytes.
> > 
> 
> Only patches 1, 2 and 5 applied to mac80211-next.
> 

To clarify - it's not that I didn't like the others, but they didn't
apply and you need to resend them against mac80211-next.

johannes
