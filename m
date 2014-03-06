Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52451 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCFTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 14:00:12 -0500
Date: Thu, 6 Mar 2014 13:47:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-03-05
Message-ID: <20140306184755.GC7788@tuxdriver.com> (sfid-20140306_200017_684294_43CE8599)
References: <1394032852.5275.41.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394032852.5275.41.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2014 at 04:20:52PM +0100, Johannes Berg wrote:
> John,
> 
> We have some more fixes...
> 
> Here I have a fix from Eliad for the minimal channel width calculation
> in the mac80211 code which lead to monitor mode not working at all for
> drivers using that. One of my fixes is for an issue noticed by Michal,
> we clear an already cleared value but do it without locking, so just
> remove that. The other is for a data leak - we leak two bytes of kernel
> memory out over the air in QoS NULL frames because those don't get a
> sequence number assigned in the TX path.
> 
> Please let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit cb664981607a6b5b3d670ad57bbda893b2528d96:
> 
>   mac80211: fix association to 20/40 MHz VHT networks (2014-02-27 20:53:01 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 864a6040f395464003af8dd0d8ca86fed19866d4:
> 
>   mac80211: clear sequence/fragment number in QoS-null frames (2014-03-05 15:49:54 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
