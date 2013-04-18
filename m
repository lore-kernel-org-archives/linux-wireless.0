Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934912Ab3DRNgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 09:36:45 -0400
Message-ID: <1366292199.8336.2.camel@jlt4.sipsolutions.net> (sfid-20130418_153649_039342_9A0471CB)
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: initialize rates selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Thu, 18 Apr 2013 15:36:39 +0200
In-Reply-To: <20130418124050.GD8638@magnum.frso.rivierawaves.com> (sfid-20130418_144515_033765_E15A74DB)
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
	 <1366287981-24134-2-git-send-email-karl.beldan@gmail.com>
	 <20130418124050.GD8638@magnum.frso.rivierawaves.com>
	 (sfid-20130418_144515_033765_E15A74DB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 14:40 +0200, Karl Beldan wrote:
> Johannes, Felix,
> 
> This seems to me like an important enough issue to IMHO, make it into
> 3.9/-stable. But since we only have a few days before Linus tags the 3.9
> I understand the boldness of the thought.

I'm not going to try for 3.9, it wouldn't happen anyway, but if you want
to tag them as Cc stable it's your call. I'm not familiar enough with
the code to really be able to judge the impact I guess. It seems
unlikely to me though that some device would support MCS 1 but not MCS
0, or MCS 9 but not 8, etc.?

johannes

