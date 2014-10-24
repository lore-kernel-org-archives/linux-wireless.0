Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60904 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaJXOdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 10:33:06 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so1231793wgh.12
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 07:33:05 -0700 (PDT)
Date: Fri, 24 Oct 2014 16:33:01 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: minstrel_ht: do not always skip ht rates
 vht_only is true
Message-ID: <20141024143301.GA3466@magnum.frso.rivierawaves.com> (sfid-20141024_163310_993287_B90B1F7E)
References: <1414152061.1934.2.camel@jlt4.sipsolutions.net>
 <1414154089-5185-1-git-send-email-karl.beldan@gmail.com>
 <1414161035.2326.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1414161035.2326.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 04:30:35PM +0200, Johannes Berg wrote:
> On Fri, 2014-10-24 at 14:34 +0200, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > When CONFIG_MAC80211_RC_MINSTREL_VHT is set, the module param
> > minstrel_vht_only tells minstrel_ht whether to allow the mix of ht rates
> > with vht rates.
> > ATM, minstrel_ht skips ht rates when minstrel_vht_only is true, but it does
> > that even if vht is not supported, which makes the sta rates fallback to
> > legacy as no ht rate gets enabled.
> 
> Applied (as is)
> 
Ok, thanks.
 
Karl
