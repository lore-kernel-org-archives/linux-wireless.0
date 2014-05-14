Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaENTpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:45:11 -0400
Date: Wed, 14 May 2014 15:41:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211: 2014-05-14
Message-ID: <20140514194121.GF14183@tuxdriver.com> (sfid-20140514_214517_041550_A28B474A)
References: <1400078307.4759.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400078307.4759.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2014 at 04:38:27PM +0200, Johannes Berg wrote:
> John,
> 
> I know I sent a pull request two days ago, but now I have more fixes ...
> if it's too much let me know and I'll limit myself to once a week or so,
> but it seemed that we should get at least Emmanuel's fix in soon.
> 
> This has a fix from Emmanuel for a problem I failed to fix - when
> association is in progress then it needs to be cancelled while
> suspending (I had fixed the same for authentication). Also included a
> fix from myself for a userspace API problem that hit the iw tool and a
> fix to the remain-on-channel framework.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit f9ac71bfcc5c937ff02765dc316cf5bc01d21d97:
> 
>   mac80211: fix vif name tracing (2014-05-09 14:35:40 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD
> 
> for you to fetch changes up to b4b177a5556a686909e643f1e9b6434c10de079f:
> 
>   mac80211: fix on-channel remain-on-channel (2014-05-14 15:48:38 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
