Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47503 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaKSVAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 16:00:11 -0500
Date: Wed, 19 Nov 2014 15:46:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-11-18
Message-ID: <20141119204640.GE13783@tuxdriver.com> (sfid-20141119_220023_505452_A2466CC8)
References: <1416347463.1939.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416347463.1939.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 18, 2014 at 10:51:03PM +0100, Johannes Berg wrote:
> John,
> 
> And another patch, I'm a bit surprised nobody found this issue before.
> 
> johannes
> 
> The following changes since commit 4f031fa9f188b2b0641ac20087d9e16bcfb4e49d:
> 
>   mac80211: Fix regression that triggers a kernel BUG with CCMP (2014-11-06 12:42:22 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-11-18
> 
> for you to fetch changes up to 280ba51d60be6f4ca3347eaa60783314f38df72e:
> 
>   mac80211: minstrel_ht: fix a crash in rate sorting (2014-11-18 22:39:16 +0100)
> 
> ----------------------------------------------------------------
> Here's another last minute fix, for minstrel HT crashing
> depending on the value of some uninitialised stack.
> 
> ----------------------------------------------------------------

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
