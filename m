Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49335 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3HVPpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 11:45:14 -0400
Date: Thu, 22 Aug 2013 11:39:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-08-21
Message-ID: <20130822153943.GD1967@tuxdriver.com> (sfid-20130822_174519_338863_5E1A764F)
References: <1377092661.15268.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377092661.15268.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 21, 2013 at 03:44:21PM +0200, Johannes Berg wrote:
> John,
> 
> I have three more patches for the 3.11 stream: Felix's fix for the
> fairly visible brcmsmac crash, a fix from Simon for an IBSS join bug I
> found and a fix for a channel context bug in IBSS I'd introduced.
> 
> Let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> The following changes since commit dee8a9732e713480075adbbca8eb220c5b8d1216:
> 
>   cfg80211: don't request disconnect if not connected (2013-08-14 14:00:19 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 75a423f493ffdf741acae27bf179cd560f7813d7:
> 
>   mac80211: ibss: fix ignored channel parameter (2013-08-21 15:33:08 +0200)
> 
> ----------------------------------------------------------------
> Felix Fietkau (1):
>       mac80211: add a flag to indicate CCK support for HT clients
> 
> Johannes Berg (1):
>       mac80211: add missing channel context release
> 
> Simon Wunderlich (1):
>       mac80211: ibss: fix ignored channel parameter

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
