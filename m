Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58065 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbaJIN0F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 09:26:05 -0400
Message-ID: <1412861162.1828.45.camel@jlt4.sipsolutions.net> (sfid-20141009_152626_065833_90732735)
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 09 Oct 2014 15:26:02 +0200
In-Reply-To: <20141009130035.GB20644@magnum.frso.rivierawaves.com> (sfid-20141009_150041_219567_F01B4BEA)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
	 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
	 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
	 (sfid-20141009_150041_219567_F01B4BEA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 15:00 +0200, Karl Beldan wrote:
> On Thu, Oct 09, 2014 at 11:32:57AM +0200, Johannes Berg wrote:
> > On Tue, 2014-10-07 at 11:42 +0200, Karl Beldan wrote:
> > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > > 
> > > ATM, specifying the frequency when connecting sends a void 'supported
> > > rates' EID.
> > 
> > Seems like this should be a stable fix?
> > 
> Indeed, I forgot to Cc stable.

Ok, I guess I can just add it.

Then again, maybe you can make a bit more verbose commit log, and check
what broke it?

johannes

