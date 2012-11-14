Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34880 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2KNTbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 14:31:19 -0500
Date: Wed, 14 Nov 2012 14:17:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi 2012-11-09
Message-ID: <20121114191714.GC6128@tuxdriver.com> (sfid-20121114_203122_834099_43E2ADC8)
References: <1352490506.28302.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352490506.28302.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 09, 2012 at 08:48:26PM +0100, Johannes Berg wrote:
> John,
> 
> Two more fixes for iwlwifi ... one to use ieee80211_free_txskb(), and
> one to check DMA mapping errors, please pull.
> 
> Thanks!
> 
> johannes
> 
> The following changes since commit 8f7b8db6e0557c8437adf9371e020cd89a7e85dc:
> 
>   iwlwifi: fix 6000 series channel switch command (2012-10-16 16:28:36 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john

Pulled...
 
> for you to fetch changes up to 31df3bb78be614fb9125abe56972dfee79bd3e18:
> 
>   iwlwifi: use ieee80211_free_txskb (2012-11-07 09:18:43 +0100)
> 
> ----------------------------------------------------------------
> Johannes Berg (2):
>       iwlwifi: handle DMA mapping failures
>       iwlwifi: use ieee80211_free_txskb
> 
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
>  drivers/net/wireless/iwlwifi/dvm/main.c     |  2 +-
>  drivers/net/wireless/iwlwifi/pcie/rx.c      | 23 +++++++++++++++++++++--
>  3 files changed, 23 insertions(+), 4 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
