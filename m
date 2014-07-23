Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59248 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWRPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 13:15:13 -0400
Date: Wed, 23 Jul 2014 13:01:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-07-22
Message-ID: <20140723170158.GC14162@tuxdriver.com> (sfid-20140723_191517_550406_27F422D5)
References: <1406064989.32255.39.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406064989.32255.39.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 22, 2014 at 11:36:29PM +0200, Johannes Berg wrote:
> John,
> 
> One more fix - for a bug in the newly introduced code that obtains rate
> control information for stations.
> 
> It would be good to get this in, otherwise we'd probably have to send it
> to stable.
> 
> johannes
> 
> The following changes since commit 8c26d458394be44e135d1c6bd4557e1c4e1a0535:
> 
>   cfg80211: fix mic_failure tracing (2014-07-18 09:53:56 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to fa8f136fe9a8fbdcb11a1db94f30146cae6d8777:
> 
>   mac80211: fix crash on getting sta info with uninitialized rate control (2014-07-22 22:17:17 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
