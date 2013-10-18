Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41853 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3JRRpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 13:45:42 -0400
Date: Fri, 18 Oct 2013 13:36:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-10-18
Message-ID: <20131018173624.GB28130@tuxdriver.com> (sfid-20131018_194545_607727_ABF86381)
References: <1382105667.14393.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382105667.14393.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 04:14:27PM +0200, Johannes Berg wrote:
> John,
> 
> I'm flushing out patches ... one more for mac80211.
> 
> This time I have two fixes for P2P (which requires not using CCK rates)
> and a workaround for APs with broken WMM information.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit d86aa4f8ca58898ec6a94c0635da20b948171ed7:
> 
>   mac80211: fix crash if bitrate calculation goes wrong (2013-10-14 09:47:08 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 095d81cee742fc31e1218077ca6ca8f0df07c613:
> 
>   mac80211: disable WMM with invalid parameters (2013-10-17 15:38:22 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
