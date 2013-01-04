Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40121 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3ADVPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 16:15:11 -0500
Date: Fri, 4 Jan 2013 16:12:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-01-03
Message-ID: <20130104211254.GC21871@tuxdriver.com> (sfid-20130104_221521_417007_39196645)
References: <1357221075.9741.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357221075.9741.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 03, 2013 at 02:51:15PM +0100, Johannes Berg wrote:
> John,
> 
> Please pull (per below). This includes a number of fixes for various
> pieces of mac80211. I've also included Thomas's memory RMC hash table
> optimisation since it saves so much memory.
> 
> Thanks,
> Johannes
> 
> 
> 
> The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:
> 
>   Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 09b1426e7fcec510aba55a761da5004e47a11ce3:
> 
>   mac80211: fix maximum MTU (2013-01-03 13:00:01 +0100)

I'm pulling this, intending to forward it to Dave early next week.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
