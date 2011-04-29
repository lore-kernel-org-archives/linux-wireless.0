Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab1D2HVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 03:21:16 -0400
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110429T084118-365@post.gmane.org> (sfid-20110429_085443_970145_470B3272)
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
	 <loom.20110429T084118-365@post.gmane.org>
	 (sfid-20110429_085443_970145_470B3272)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 09:21:15 +0200
Message-ID: <1304061675.3589.1.camel@jlt3.sipsolutions.net> (sfid-20110429_092120_017819_D9BAA70B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-29 at 06:54 +0000, Alexander Simon wrote:
> > Well. You need to consider more than just this. I have a feeling you're
> > only considering fixed channel use cases. But if we configure HT40+, and
> > then find a peer on a channel that may only use HT40-, then what?
> 
> Good point. But still i think this is the same case. Right now, the card would
> still be set into HT40+, regardless of the frequency. Then, minstrel_ht would
> just use HT20, i suppose.
> 
> My proposal would be making the HT iw argument non-advisory: Use it when
> creating a network, discard it when joining one.

Yeah it would be an option to just always join as HT if HT is available,
but not create as HT unless asked.

johannes

