Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45186 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab3BRUaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 15:30:12 -0500
Date: Mon, 18 Feb 2013 15:28:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-02-18
Message-ID: <20130218202844.GE12505@tuxdriver.com> (sfid-20130218_213016_214429_969928FF)
References: <1361216202.8555.49.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361216202.8555.49.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 18, 2013 at 08:36:42PM +0100, Johannes Berg wrote:
> John,
> 
> Like iwlwifi-next, this would almost be suitable for rc1.
> 
> I have a fix for station management on non-TDLS drivers, a CAB queue
> crash fix for mesh, a fix for an annoying (but harmless) warning, a
> tracing fix and a documentation fix. Other than that, only a few mesh
> cleanups.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> The following changes since commit 93c78c5debeb9c7101ecc73347d4730c26a98c05:
> 
>   mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv (2013-02-15 09:41:45 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 8c6d59ee3509acd474365c34db291b950d2e66bf:
> 
>   cfg80211: fix station change if TDLS isn't supported (2013-02-18 18:26:24 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
