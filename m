Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6502 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0CXVqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:46:46 -0400
Subject: Re: [PATCH] compat-wireless: update 22-multiqueue.patch for the
 current linux-next
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1269466122.6935.7.camel@jlt3.sipsolutions.net>
References: <20100324212520.15474.94735.stgit@mj.roinet.com>
	 <1269466122.6935.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Wed, 24 Mar 2010 17:46:44 -0400
Message-Id: <1269467204.26368.33.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 14:28 -0700, Johannes Berg wrote:
> On Wed, 2010-03-24 at 17:25 -0400, Pavel Roskin wrote:
> > Adjust for spacing change in net/mac80211/util.c.  Add a replacement for
> > netif_tx_wake_queue() for net/mac80211/tx.c
> > 
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > ---
> >  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> Out of curiosity, how did you manage to generate that?

If you mean "0 files changed", I guess it's a bug in STGit.

If you mean the patch. I applied the original patch to util.c with "-l",
made sure that it's sane, adjusted spacing and added the patch to STGit.
Then I found that the same construct propagated to tx.c, so I added the
same ifdefs there, made a diff and added in manually to the existing
diff for tx.c.

-- 
Regards,
Pavel Roskin
