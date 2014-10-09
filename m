Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59486 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaJISfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 14:35:32 -0400
Message-ID: <1412879729.1828.60.camel@jlt4.sipsolutions.net> (sfid-20141009_203538_314111_2C8E6CAB)
Subject: Re: [PATCH] mac80211/trivial: fix typo in starting baserate for
 rts_cts_rate_idx
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 09 Oct 2014 20:35:29 +0200
In-Reply-To: <20141009162827.GB27065@magnum.frso.rivierawaves.com> (sfid-20141009_182832_812778_F87DC453)
References: <1412690018-18429-1-git-send-email-karl.beldan@gmail.com>
	 <1412845586.1828.27.camel@jlt4.sipsolutions.net>
	 <20141009140636.GC20644@magnum.frso.rivierawaves.com>
	 <1412864103.1828.48.camel@jlt4.sipsolutions.net>
	 <20141009144548.GD20644@magnum.frso.rivierawaves.com>
	 <1412868141.1828.57.camel@jlt4.sipsolutions.net>
	 <20141009162827.GB27065@magnum.frso.rivierawaves.com>
	 (sfid-20141009_182832_812778_F87DC453)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 18:28 +0200, Karl Beldan wrote:

> > But it's still pretty misbehaving, no? That IMHO warrants fixing and
> > even cc stable.

> You'd like me to reword with these details in a v2 and cc stable or ?

Yes please, if you don't mind.

johannes

