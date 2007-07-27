Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52122 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754676AbXG0Mii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 08:38:38 -0400
Date: Fri, 27 Jul 2007 14:38:36 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: BUG sleeping function called from invalid context
Message-ID: <20070727143836.715fbe61@griffin.suse.cz>
In-Reply-To: <200707271427.27261.mb@bu3sch.de>
References: <200707271427.27261.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Jul 2007 14:27:26 +0200, Michael Buesch wrote:
> [  183.950972] BUG: sleeping function called from invalid context at mm/slab.c:3024
> [  183.951305] in_atomic():1, irqs_disabled():0
> [  183.952456] Call Trace:
> [  183.953521] [db633cc0] [c0008978] show_stack+0x50/0x184 (unreliable)
> [  183.954780] [db633ce0] [c002a164] __might_sleep+0xc0/0xd4
> [  183.955982] [db633cf0] [c007862c] kmem_cache_alloc+0x34/0x118
> [  183.957198] [db633d10] [e25fa20c] ieee80211_sta_scan_results+0x548/0x750 [mac80211]

Fix was posted in http://thread.gmane.org/gmane.linux.kernel.wireless.general/3939

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
