Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51618 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0BOHRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 02:17:23 -0500
Subject: Re: [PATCH] mac80211: fix netdev rename
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1265967905.4388.0.camel@jlt3.sipsolutions.net>
References: <1265967905.4388.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 02:17:12 -0500
Message-Id: <1266218232.28738.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-12 at 10:45 +0100, Johannes Berg wrote:
> Fix a copy bug introduced by
> 
>     commit 47846c9b0c10808d9337d2e7d09361f3e0a0a71a
>     Author: Johannes Berg <johannes@sipsolutions.net>
>     Date:   Wed Nov 25 17:46:19 2009 +0100
> 
>         mac80211: reduce reliance on netdev
> 
> This manifested itself only in debug messages
> and in the debugfs rename failure that would
> always happen due to trying to rename the dir
> over itself.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org

Tested-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
