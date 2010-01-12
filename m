Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36780 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0ALRPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 12:15:22 -0500
Date: Tue, 12 Jan 2010 12:09:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix WMM AC default for non-QoS data frames
Message-ID: <20100112170907.GC2987@tuxdriver.com>
References: <4B4BE7AA.4060808@openwrt.org> <43e72e891001120852t221106cx4f20ae03959e17e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001120852t221106cx4f20ae03959e17e6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 08:52:32AM -0800, Luis R. Rodriguez wrote:
> On Mon, Jan 11, 2010 at 7:08 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> > The WMM AC selection added to the monitor mode selection function
> > accidentally assigns non-QoS data frames to the same AC as mgmt frames
> > (VO). This is not serious, but should be fixed anyway. This patch
> > assigns them to the BE AC instead.
> >
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> This one I guess is the one I mean John. Someone correct me if I'm
> wrong but I believe this piggy backs on top of all the recent fixes
> and is a stable candidate.

It's not marked for stable.  The "This is not serious..." in the
changelog was non-motivational in that regard. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
