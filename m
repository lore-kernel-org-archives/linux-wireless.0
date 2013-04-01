Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57521 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302Ab3DATPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:15:52 -0400
Date: Mon, 1 Apr 2013 15:10:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-03-28
Message-ID: <20130401191029.GB3526@tuxdriver.com> (sfid-20130401_211601_537882_141D607F)
References: <1364484573.10397.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364484573.10397.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 04:29:33PM +0100, Johannes Berg wrote:
> John,
> 
> Before I disappear for Easter vacation, I decided to send you two more
> mac80211 fixes.
> 
> I had changed the idle handling to simplify it, but broken the
> sequencing of commands, at least for ath9k-htc, one patch restores the
> sequence. The other patch fixes a crash Jouni found while stress-testing
> the remain-on-channel code, when an item is deleted the work struct can
> run twice and crash the second time.
> 
> Please pull. Thanks,
> johannes
> 
> 
> The following changes since commit 370bd005937c0e00f9104a602f9fe1dd6b21b54b:
> 
>   mac80211: Don't restart sta-timer if not associated. (2013-03-24 11:15:59 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 382a103b2b528a3085cde4ac56fc69d92a828b72:
> 
>   mac80211: fix idle handling sequence (2013-03-25 16:50:18 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
