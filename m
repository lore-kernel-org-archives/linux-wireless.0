Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3CVKbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:31:39 -0400
Message-ID: <1363948291.8238.10.camel@jlt4.sipsolutions.net> (sfid-20130322_113143_562814_FE2159F6)
Subject: Re: [PATCH 1/2] mac80211:  Make beacon-loss-count configurable.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 11:31:31 +0100
In-Reply-To: <1363727997-1554-1-git-send-email-greearb@candelatech.com> (sfid-20130319_222010_382492_3F895FA6)
References: <1363727997-1554-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130319_222010_382492_3F895FA6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 14:19 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> On loaded systems with lots of VIFs, I see lots of beacon
> timeouts, even though the connection to the AP is very
> good.  Allow tuning the beacon-loss-count variable to
> give the system longer to process beacons if the user
> prefers.

Applied, I also added the number to the message, just in case somebody
sets it to 0 or 1 or something like that ... :-)

johannes

