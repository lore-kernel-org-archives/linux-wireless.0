Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53004 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945931AbbGQNuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:50:35 -0400
Message-ID: <1437141022.1933.26.camel@sipsolutions.net> (sfid-20150717_155055_716841_66D101D6)
Subject: Re: [PATCH] mac80211: Deinline rate_control_rate_init,
 rate_control_rate_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Denys Vlasenko <dvlasenk@redhat.com>,
	John Linville <linville@tuxdriver.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 17 Jul 2015 15:50:22 +0200
In-Reply-To: <1436964966-2441-2-git-send-email-dvlasenk@redhat.com> (sfid-20150715_145648_616165_75545060)
References: <1436964966-2441-1-git-send-email-dvlasenk@redhat.com>
	 <1436964966-2441-2-git-send-email-dvlasenk@redhat.com>
	 (sfid-20150715_145648_616165_75545060)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-15 at 14:56 +0200, Denys Vlasenko wrote:
> With this .config: http://busybox.net/~vda/kernel_config,
> after deinlining these functions have sizes and callsite counts
> as follows:
> 
> rate_control_rate_init: 554 bytes, 8 calls
> rate_control_rate_update: 1596 bytes, 5 calls
> 
> Total size reduction: about 11 kbytes.
> 
Both applied.

johannes
