Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2GIN3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:29:41 -0400
Message-ID: <1341840577.4455.49.camel@jlt3.sipsolutions.net> (sfid-20120709_152944_548886_30374248)
Subject: Re: [PATCH] Fix oops when set_monitor_enabled() not defined in the
 struct cfg80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 09 Jul 2012 15:29:37 +0200
In-Reply-To: <87liit2hi2.fsf@purkki.adurom.net>
References: <1341745690-12574-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341745890.4987.6.camel@jlt3.sipsolutions.net>
	 <87liit2hi2.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 16:25 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Sun, 2012-07-08 at 14:08 +0300, Vladimir Kondratiev wrote:
> >> Quick fix for method being invoked without checking its existence
> >> 
> >> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> [...]
> 
> >
> > Oh, good catch, applied
> 
> Title is missing "cfg80211: " prefix. Is it too late to change that?

I fixed it when applying :-)

http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=commitdiff;h=56af8f9af99223610f0582594bd4ac0a0320eb71

johannes

