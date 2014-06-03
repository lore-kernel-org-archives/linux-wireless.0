Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60223 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaFCTtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:49:47 -0400
Message-ID: <1401824973.4157.38.camel@jlt4.sipsolutions.net> (sfid-20140603_214950_327362_60483622)
Subject: Re: [PATCH v7 3/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 03 Jun 2014 21:49:33 +0200
In-Reply-To: <1401348851-26732-4-git-send-email-michal.kazior@tieto.com> (sfid-20140529_094147_939758_C4ED52D9)
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	 <1401348851-26732-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140529_094147_939758_C4ED52D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-29 at 09:34 +0200, Michal Kazior wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls csa_finish(), the other
> is when reservation is actually finalized (which
> can be deferred for in-place reservation).
> 
> It is now safe to call ieee80211_csa_finish() more
> then once.

"more than once" :-)

johannes

