Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33171 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaJXOai (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 10:30:38 -0400
Message-ID: <1414161035.2326.0.camel@jlt4.sipsolutions.net> (sfid-20141024_163042_261057_3FC9B820)
Subject: Re: [PATCH] mac80211: minstrel_ht: do not always skip ht rates
 vht_only is true
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 24 Oct 2014 16:30:35 +0200
In-Reply-To: <1414154089-5185-1-git-send-email-karl.beldan@gmail.com> (sfid-20141024_143503_370400_04F82901)
References: <1414152061.1934.2.camel@jlt4.sipsolutions.net>
	 <1414154089-5185-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141024_143503_370400_04F82901)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-24 at 14:34 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When CONFIG_MAC80211_RC_MINSTREL_VHT is set, the module param
> minstrel_vht_only tells minstrel_ht whether to allow the mix of ht rates
> with vht rates.
> ATM, minstrel_ht skips ht rates when minstrel_vht_only is true, but it does
> that even if vht is not supported, which makes the sta rates fallback to
> legacy as no ht rate gets enabled.

Applied (as is)

johannes

