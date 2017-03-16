Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39138 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCPGzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 02:55:47 -0400
Message-ID: <1489647339.2370.0.camel@sipsolutions.net> (sfid-20170316_075600_059606_EF2585CA)
Subject: Re: [PATCH] nl80211: fix dumpit error path RTNL deadlocks
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sowmini.varadhan@oracle.com, dvyukov@google.com
Date: Thu, 16 Mar 2017 07:55:39 +0100
In-Reply-To: <20170315.145902.1038598966216203408.davem@davemloft.net>
References: <20170315132913.26088-1-johannes@sipsolutions.net>
         <20170315.145902.1038598966216203408.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-15 at 14:59 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 15 Mar 2017 14:29:13 +0100
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Sowmini pointed out Dmitry's RTNL deadlock report to me, and it
> turns out
> > to be perfectly accurate - there are various error paths that miss
> unlock
> > of the RTNL.

> Johannes, I assume I will get this in a future pull request?

Sure, coming to a tree near you ... today I guess. Just didn't want to
send it out entirely unreviewed, although I checked it with sparse.

johannes
