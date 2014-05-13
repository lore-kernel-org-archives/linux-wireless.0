Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177AbaEMKIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 06:08:15 -0400
Message-ID: <1399975686.4137.9.camel@jlt4.sipsolutions.net> (sfid-20140513_120823_948368_131A2875)
Subject: Re: [PATCH] mac80211: fix suspend vs. association race
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 May 2014 12:08:06 +0200
In-Reply-To: <1399974849-12353-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399974849-12353-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-13 at 12:54 +0300, Emmanuel Grumbach wrote:
> If the association is in progress while we suspend, the
> stack will be in a messed up state. Clean it before we
> suspend.
> 
> This patch completes Johannes's patch:
> 
> 1a1cb744de160ee70086a77afff605bbc275d291
> Author: Johannes Berg <johannes.berg@intel.com>
> 
>     mac80211: fix suspend vs. authentication race
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Applied, thanks.

johannes

