Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54001 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcCCJhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 04:37:15 -0500
Message-ID: <1456997824.2044.5.camel@sipsolutions.net> (sfid-20160303_103720_751794_28BA058C)
Subject: Re: [PATCH 2/2] mac80211: mesh: convert path table to rhashtable
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>, me@bobcopeland.com
Cc: linux-wireless@vger.kernel.org, tgraf@suug.ch,
	netdev@vger.kernel.org
Date: Thu, 03 Mar 2016 10:37:04 +0100
In-Reply-To: <20160302.144359.2141637165742439224.davem@davemloft.net>
References: <1456931360-2846-1-git-send-email-me@bobcopeland.com>
	 <1456931360-2846-2-git-send-email-me@bobcopeland.com>
	 <20160302.144359.2141637165742439224.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 14:43 -0500, David Miller wrote:
> From: Bob Copeland <me@bobcopeland.com>
> Date: Wed,  2 Mar 2016 10:09:20 -0500
> 
> > In the time since the mesh path table was implemented as an
> > RCU-traversable, dynamically growing hash table, a generic RCU
> > hashtable implementation was added to the kernel.
> > 
> > Switch the mesh path table over to rhashtable to remove some code
> > and also gain some features like automatic shrinking.
> > 
> > Cc: Thomas Graf <tgraf@suug.ch>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Bob Copeland <me@bobcopeland.com>
> 
> Johannes, feel free to take both patches via your tree, thanks.

Will do, thanks.

johannes
