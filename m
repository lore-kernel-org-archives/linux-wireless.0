Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2KIUU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:20:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWv4T-0003vF-PV
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 21:20:58 +0100
Message-ID: <1352492493.28302.7.camel@jlt4.sipsolutions.net> (sfid-20121109_212102_557650_EBADED17)
Subject: Re: VHT support, take 2
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 21:21:33 +0100
In-Reply-To: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211702_930840_209B43F6)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121109_211702_930840_209B43F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-09 at 21:17 +0100, Johannes Berg wrote:

> What I intend to do next is this have a patch to parse the VHT
> operation IE in mac80211 (or have a helper in cfg80211?) to
> select the VHT channel configuration in MLME code.
> 
> I'm kinda hoping the posedge folks will come back with the
> regulatory code so I don't have to worry about that ...
> *hint hint* :-)
> 
> After that, I'll need to work on the remaining hostapd code,
> that should just need channel configuration etc. now. Then I
> think it just needs a good test run.
> 
> I'm not interested in VHT IBSS, so I'm not going to do anything
> there, nor VHT mesh.
> 
> The other thing would be rate control, e.g. minstrel_vht, but
> I'm not sure we can use minstrel at all, so I'll probalby not
> work on minstrel myself.

Oh and then of course there's also a whole bunch of action frame
handling that will be needed in mac80211, but I'm not really sure yet
what that actually is.

johannes

