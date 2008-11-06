Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37123 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYKFObJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:31:09 -0500
Date: Thu, 6 Nov 2008 08:58:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: johannes@sipsolutions.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] cfg80211/mac80211: Add 802.11d support
Message-ID: <20081106135834.GC14184@tuxdriver.com> (sfid-20081106_153132_867102_14C9CBA7)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com> <43e72e890811051216w26acca38t6eb26081509bdf28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890811051216w26acca38t6eb26081509bdf28@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2008 at 12:16:57PM -0800, Luis R. Rodriguez wrote:
> On Tue, Nov 4, 2008 at 6:49 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > This patch series adds 802.11d support to mac80211 and
> > cfg80211. I've tried to split the required changes as much
> > as possible to make it easier for review. I've tested this
> > on iwlagn with OLD_REG enabled and disable and with /sbin/crda
> > missing and not. I'm sure I've missed a few corner cases, but
> > I think this is a good start.
> 
> OK John here's the review, in case it helps
> 
> patch 1-5 are ACKed
> patch 6 is unnecessary
> I'll respin patch 7, and actually I'll split it in two to account for
> the call_crda() return value thing.

Hey, thanks for the recap!

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
