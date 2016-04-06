Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33018 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbcDFHT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:19:57 -0400
Message-ID: <1459927188.17504.4.camel@sipsolutions.net> (sfid-20160406_091959_451548_B1F50809)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net
Date: Wed, 06 Apr 2016 09:19:48 +0200
In-Reply-To: <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com> (sfid-20160406_073548_268435_E6515D94)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	 <1459864656.18188.60.camel@sipsolutions.net>
	 <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com>
	 (sfid-20160406_073548_268435_E6515D94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 07:35 +0200, Michal Kazior wrote:

> I just wanted to follow the suggested/implied usage of codel code and
> keep modifications to a minimum. I could very well just assimilate it
> if you wish.

I don't really feel all that strongly about it, but I also don't see
the point. It makes it harder to look for the code though, and that
seems fairly pointless.

Btw, just realized that there's also __u32 in there which you should
probably remove and use just u32. Also don't #include <linux/version.h>


> This follows net/sched/sch_fq_codel.h. I can put up a comment to
> explain what it's supposed to do?
> 

Ok, fair enough.

johannes
