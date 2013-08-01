Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43401 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HATaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 15:30:12 -0400
Date: Thu, 1 Aug 2013 15:27:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-07-26
Message-ID: <20130801192723.GD13922@tuxdriver.com> (sfid-20130801_213017_078866_0D56AEFD)
References: <1374827740.8248.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374827740.8248.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 10:35:40AM +0200, Johannes Berg wrote:
> John,
> 
> This is a more traditional pull request without patches since they've
> all been to the list :-) First set of updates for mac80211-next.
> 
> The biggest change here is probably the initial 5/10 MHz support for
> IBSS, the remaining patches are smaller features and some cleanups.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> 
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to c82b5a74cc739385db6e4275fe504a0e9469bf01:
> 
>   mac80211: make active monitor injection work w/ HW queue (2013-07-16 09:58:19 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
