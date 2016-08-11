Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51247 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbcHKIDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 04:03:23 -0400
Message-ID: <1470902592.5266.9.camel@sipsolutions.net> (sfid-20160811_100343_171659_94634CAB)
Subject: Re: [PATCH v3] mac80211: mesh: Add support for HW RC implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 10:03:12 +0200
In-Reply-To: <20160711141539.30281-1-maxim.altshul@ti.com> (sfid-20160711_161329_640467_3295897C)
References: <20160711141539.30281-1-maxim.altshul@ti.com>
	 (sfid-20160711_161329_640467_3295897C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-11 at 17:15 +0300, Maxim Altshul wrote:
> Mesh HWMP module will be able to rely on the HW
> RC algorithm if it exists, for path metric calculations.
> 
> This allows the metric calculation mechanism to calculate
> a correct metric, based on PER and last TX rate both via
> HW RC algorithm if it exists or via parameters collected
> by the SW.
> 
Applied. I decided to put the fix for the sta->uploaded thing into
mac80211-next, since there's no driver affected by it now, so please
base that patch on this one, if necessary.

johannes
