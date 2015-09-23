Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60288 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbbIWJAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:00:49 -0400
Message-ID: <1442998845.1889.2.camel@sipsolutions.net> (sfid-20150923_110055_809652_BFBBCE0D)
Subject: Re: [PATCH] mac80211: minstrel[_ht]: remove non-ascii debugfs
 characters
From: Johannes Berg <johannes@sipsolutions.net>
To: Bastian Bittorf <bittorf@bluebottle.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 23 Sep 2015 11:00:45 +0200
In-Reply-To: <20150923084935.GD6319@medion.lan> (sfid-20150923_105920_696562_4775F523)
References: <1442997041-8916-1-git-send-email-johannes@sipsolutions.net>
	 <20150923084935.GD6319@medion.lan> (sfid-20150923_105920_696562_4775F523)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-23 at 10:49 +0200, Bastian Bittorf wrote:
> * Johannes Berg <johannes@sipsolutions.net> [23.09.2015 10:44]:
> > Replace the average symbol by "avg" to avoid being warned about the
> > non-ASCII symbol all the time, line up the columns properly.
> 
> who warns you? the compiler? the terminal?
> 

sparse, or perhaps smatch? either way, those tools are crucial for my
workflow, and there seems to be very little downside to the change.

johannes
