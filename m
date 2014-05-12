Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43809 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaELSPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 14:15:09 -0400
Date: Mon, 12 May 2014 14:13:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-05-12
Message-ID: <20140512181353.GN17022@tuxdriver.com> (sfid-20140512_201518_811393_38E2C1EA)
References: <1399903516.4337.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399903516.4337.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2014 at 04:05:16PM +0200, Johannes Berg wrote:
> Hi John
> 
> Two more fixes - both I've been sitting on, sorry
> 
> One fix is to get better VHT performance and the other fixes tracing
> garbage or other potential issues with the interface name tracing.
> 
> Let me know if there are any issues.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit e669ba2d06c6195662601956454ac959892f0762:
> 
>   mac80211: fix nested rtnl locking on ieee80211_reconfig (2014-05-05 15:14:58 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD
> 
> for you to fetch changes up to f9ac71bfcc5c937ff02765dc316cf5bc01d21d97:
> 
>   mac80211: fix vif name tracing (2014-05-09 14:35:40 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
