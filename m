Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50478 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbcF2HUM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 03:20:12 -0400
Message-ID: <1467184807.2461.5.camel@sipsolutions.net> (sfid-20160629_092057_214820_5CCBC15C)
Subject: Re: [PATCH] mac80211: util: mesh is not connected properly after
 recovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Maital Hahn <maitalm@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 29 Jun 2016 09:20:07 +0200
In-Reply-To: <20160628111546.8932-1-yanivma@ti.com> (sfid-20160628_131320_130252_9109DD97)
References: <20160628111546.8932-1-yanivma@ti.com>
	 (sfid-20160628_131320_130252_9109DD97)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-28 at 14:15 +0300, Yaniv Machani wrote:
> From: Maital Hahn <maitalm@ti.com>
> 
> In the reconfigure process for mesh interface, moved the
> reconfiguration
> of the mesh peers to be done only after restarting the beacons,
> the same as it is done for AP.
> 
> Signed-off-by: Maital Hahn <maitalm@ti.com>
> Acked-by: Yaniv Machani <yanivma@ti.com>
> 
Same here, and this also needs a description of why this is OK with
other drivers, since presumably it already works there.

johannes
