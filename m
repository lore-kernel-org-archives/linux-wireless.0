Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53102 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKJSPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 13:15:12 -0500
Date: Mon, 10 Nov 2014 13:09:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-11-10
Message-ID: <20141110180936.GB26371@tuxdriver.com> (sfid-20141110_191516_872918_505F3373)
References: <1415615519.1847.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415615519.1847.10.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2014 at 11:31:59AM +0100, Johannes Berg wrote:
> Hi John,
> 
> One more for 3.18, if possible.
> 
> johannes
> 
> The following changes since commit b8fff407a180286aa683d543d878d98d9fc57b13:
> 
>   mac80211: fix use-after-free in defragmentation (2014-11-03 14:28:50 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-11-10
> 
> for you to fetch changes up to 4f031fa9f188b2b0641ac20087d9e16bcfb4e49d:
> 
>   mac80211: Fix regression that triggers a kernel BUG with CCMP (2014-11-06 12:42:22 +0100)
> 
> ----------------------------------------------------------------
> This has just one fix, for an issue with the CCMP decryption
> that can cause a kernel crash. I'm not sure it's remotely
> exploitable, but it's an important fix nonetheless.
> 
> ----------------------------------------------------------------
> Ronald Wahl (1):
>       mac80211: Fix regression that triggers a kernel BUG with CCMP
> 
>  net/mac80211/aes_ccm.c | 3 +++
>  1 file changed, 3 insertions(+)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
