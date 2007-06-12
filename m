Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3565 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXFLOYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 10:24:40 -0400
Date: Tue, 12 Jun 2007 10:02:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070612140217.GC310@tuxdriver.com>
References: <20070606082152.GA28639@mail.intel.com> <20070607224315.6dadffca@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070607224315.6dadffca@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 07, 2007 at 10:43:15PM +0200, Jiri Benc wrote:
> On Wed, 6 Jun 2007 16:21:54 +0800, Zhu Yi wrote:
> > This is a patch series for IEEE802.11e/WMM support against
> > linux-2.6.22-rc4.
> > 
> > [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
> > [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
> > [PATCH 3/3] mac80211: debugfs support for TSM and DLS

> I see you already applied those patches. I haven't had a time to look
> at the second patch in this resent version yet, but even from the first
> and third one it's clear they still need a lot of work (for example,
> adding cfg80211 support instead of that debugfs interface isn't going
> to be a few lines long patch).
> 
> Please revert them.

I think you will agree that Yi has been making a good effort to correct
problems identified with this patch series.  I think it is best to
continue integrating those patches into the wireless-dev tree for now.

Once the code is agreeable to those concerned (including a reasonable
API for DLS establishment), then we can ask for Yi (or someone else)
to submit a clean patchset for sending upstream.  As long as the
individual patches are focused on a particular feature, git provides
facilities for combining patches that are fairly robust and easy
to manage.  So, creating a clean patchset should be no great hardship.

John

P.S.  The future of wireless-dev is still open for dicussion.  I think
it can still be useful for integrating "in progress" patches and
feeding them to -mm for early testing.  However, I definitely would
like to reduce the delta between wireless-dev and wireless-2.6 as
much as possible and as soon as possible.
-- 
John W. Linville
linville@tuxdriver.com
