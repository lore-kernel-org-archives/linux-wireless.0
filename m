Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46928 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbbFQJO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:14:59 -0400
Message-ID: <1434532497.1884.27.camel@sipsolutions.net> (sfid-20150617_111504_968031_7299EB0C)
Subject: Re: [PATCH] iw:  Use ifname if available, print new/del/stop events.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:14:57 +0200
In-Reply-To: <1433974675-19225-1-git-send-email-greearb@candelatech.com>
References: <1433974675-19225-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 18:17 -0400, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If the kernel sends the IFNAME in the netlink message, then
> use it to save the call to map ifindex to name (and
> potentially fix races, especially when kernel is
> busy deleting an interface.

Please split the "print new/del/stop events" part into a separate patch
- I can apply that now.

johannes

