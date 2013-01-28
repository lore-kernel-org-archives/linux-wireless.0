Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48801 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3A1UAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 15:00:23 -0500
Date: Mon, 28 Jan 2013 14:47:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-01-24
Message-ID: <20130128194712.GB2107@tuxdriver.com> (sfid-20130128_210027_686890_92D4A65D)
References: <1359045275.21908.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359045275.21908.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 05:34:35PM +0100, Johannes Berg wrote:
> John,
> 
> One fix from Dan for a possible memory overrun.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit 8680451f38a64bd270233b3c0eeb7c45f2b5efe3:
> 
>   mac80211: add encrypt headroom to PERR frames (2013-01-16 23:24:51 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to c49dc9008b1c641a86837297df7c90cef070571b:
> 
>   cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       cfg80211: off by one in ieee80211_bss()
> 
>  net/wireless/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
