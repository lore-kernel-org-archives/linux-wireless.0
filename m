Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51325 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbbI3ROe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 13:14:34 -0400
Message-ID: <1443633267.1859.11.camel@sipsolutions.net> (sfid-20150930_191437_446438_784AADED)
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Date: Wed, 30 Sep 2015 19:14:27 +0200
In-Reply-To: <560C036C.7000401@candelatech.com>
References: <5605D228.7050609@candelatech.com>
	 (sfid-20150926_010105_789618_F93D668E) <1443595615.1859.2.camel@sipsolutions.net>
	 <560BFABC.8090504@candelatech.com>
	 <1443626224.1859.9.camel@sipsolutions.net>
	 <560C036C.7000401@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-30 at 08:44 -0700, Ben Greear wrote:
> 
> Any idea how this could be done in the stack instead of the driver?

I don't see why it should be?

> The problem is that this is a receiver-side issue, so even if I manage
> to hack the ath10k firmware or driver rx logic, it would not fix any other
> IBSS peer connected to ath10k peer.
> 

You mean it's a transmitter-side issue? In that case you should
probably simply disable aggregation on the broken transmitter ...

johannes
