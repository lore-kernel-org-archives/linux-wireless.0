Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268Ab2COSwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:52:11 -0400
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331833159-12694-2-git-send-email-greearb@candelatech.com> (sfid-20120315_183942_222982_FD61EFBD)
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
	 <1331833159-12694-2-git-send-email-greearb@candelatech.com>
	 (sfid-20120315_183942_222982_FD61EFBD)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:52:11 +0100
Message-ID: <1331837531.3432.36.camel@jlt3.sipsolutions.net> (sfid-20120315_195216_155517_CF3D3FCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This lets ethtool print out stats related to station
> interfaces.  Does not yet get stats from the underlying
> driver.

Hmm. What's the advantage of using ethtool over iw, which already has a
bunch of these numbers?

johannes

