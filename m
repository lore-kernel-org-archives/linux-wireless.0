Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbbKQPOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 10:14:17 -0500
Message-ID: <1447773252.14408.9.camel@sipsolutions.net> (sfid-20151117_161437_065397_93E9AF71)
Subject: linux-next inclusion request for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2015 16:14:12 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

Could you please add my mac80211 and mac80211-next trees, found at

git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git

with their 'master' branches to linux-next?

These trees are feeding net and net-next respectively, but I don't
always send them immediately and it'd be good to have early integration
with other things happening elsewhere, in particular of course with the
wifi drivers found in wireless-drivers{,-next}.

Thanks,
johannes
