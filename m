Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2CQJHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 05:07:40 -0400
Subject: Re: [PATCH v2 2/4] mac80211:  Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1331927952-8706-2-git-send-email-greearb@candelatech.com> (sfid-20120316_205945_542022_CB39D3A7)
References: <1331927952-8706-1-git-send-email-greearb@candelatech.com>
	 <1331927952-8706-2-git-send-email-greearb@candelatech.com>
	 (sfid-20120316_205945_542022_CB39D3A7)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Mar 2012 10:07:36 +0100
Message-ID: <1331975256.4523.57.camel@jlt3.sipsolutions.net> (sfid-20120317_100751_005883_6B49C0C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 12:59 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This lets ethtool print out stats related to station
> interfaces.

That's kinda misleading -- it makes it print out "stats related to
stations connected to the interface" :-)

johannes

