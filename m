Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56124 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaKZKpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 05:45:13 -0500
Message-ID: <1416998709.2019.5.camel@sipsolutions.net> (sfid-20141126_114518_357195_9DE3FBDB)
Subject: Re: [PATCH v7] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Nov 2014 11:45:09 +0100
In-Reply-To: <1416997856.2703.29.camel@jrissane-mobl.ger.corp.intel.com>
References: <1416992841-15728-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141126_100742_107746_BD7B37FA) <1416994339.2019.4.camel@sipsolutions.net>
	 <1416997856.2703.29.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-26 at 12:30 +0200, Jukka Rissanen wrote:

> > Just some examples:
> >  * don't synchronize_rcu() after assignment - what did you do that for?
> 
> Following the examples described in Documentation/RCU/whatisRCU.txt

Hmm, I don't think that documentation says that - was where you took it
from the example of replacing? But it's only needed for freeing, not for
assigning.

johannes

