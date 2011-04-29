Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1D2MjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 08:39:09 -0400
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1304080563.2931.41.camel@alex-2> (sfid-20110429_143612_006856_91560407)
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
	 <loom.20110429T084118-365@post.gmane.org>
	 (sfid-20110429_085443_970145_470B3272)  <1304061675.3589.1.camel@jlt3.sipsolutions.net>
	 <1304066264.2931.23.camel@alex-2>  <1304080563.2931.41.camel@alex-2>
	 (sfid-20110429_143612_006856_91560407)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 14:39:07 +0200
Message-ID: <1304080747.21342.1.camel@jlt3.sipsolutions.net> (sfid-20110429_143913_338536_839C9EB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-29 at 14:36 +0200, Alexander Simon wrote:


> - If HT has been configured through iw and a non-HT network is to be
> joined, iw's HT setting is used and announced.

This isn't possible, you might join a network on a channel that doesn't
allow HT40+ for example.

johannes

