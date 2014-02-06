Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35054 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaBFUaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 15:30:12 -0500
Date: Thu, 6 Feb 2014 15:29:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-02-06
Message-ID: <20140206202928.GD3181@tuxdriver.com> (sfid-20140206_213017_365895_1700D8B9)
References: <1391677237.12789.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391677237.12789.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 06, 2014 at 10:00:37AM +0100, Johannes Berg wrote:
> Hi John,
> 
> First round of fixes ...
> 
> This is just a collection of small fixes, the commit logs explain the
> details. The only thing that isn't strictly a fix is the 5/10 MHz
> enabling, I had forgotten this and there's little point in waiting
> longer. The patch simply removes the force-disable code that I put in
> when there was a problem with the userspace API (that has long been
> fixed.)
> 
> Please pull.
> 
> johannes
> 
> 
> 
> The following changes since commit 53d8ab29f8f6d67e37857b68189b38fa3d87dd8e:
> 
>   Merge branch 'for-3.14/drivers' of git://git.kernel.dk/linux-block (2014-01-30 11:40:10 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to fab57a6cc227468ca9e6a4c7ff8d3b10727785ee:
> 
>   mac80211: fix virtual monitor interface iteration (2014-02-06 09:55:22 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
