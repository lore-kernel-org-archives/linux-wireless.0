Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53980 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3GVUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 16:15:13 -0400
Date: Mon, 22 Jul 2013 16:01:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: 2013-07-22
Message-ID: <20130722200124.GA29803@tuxdriver.com> (sfid-20130722_221518_178538_0B3DD7C7)
References: <1374494325.14517.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374494325.14517.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 22, 2013 at 01:58:45PM +0200, Johannes Berg wrote:
> John,
> 
> Here's a pull request for 3.11 (and some fixes with cc stable), sorry
> for the delay - I was travelling.
> 
> Here I have a fix for RSSI thresholds in mesh, two minstrel fixes from
> Felix, an nl80211 fix from Michal and four various fixes I did myself.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> 
> The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> 
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 5c9fc93bc9bc417418fc1b6366833ae6a07b804d:
> 
>   mac80211/minstrel: fix NULL pointer dereference issue (2013-07-16 17:48:14 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
