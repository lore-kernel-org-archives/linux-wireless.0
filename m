Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33370 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbcHAJlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 05:41:44 -0400
Message-ID: <1470044373.3389.20.camel@sipsolutions.net> (sfid-20160801_114210_377428_1D7C5A43)
Subject: Re: [PATCH v2 1/3] mac80211: mesh: flush stations before beacons
 are stopped
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Maital Hahn <maitalm@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 01 Aug 2016 11:39:33 +0200
In-Reply-To: <20160713114449.24665-1-yanivma@ti.com> (sfid-20160713_134104_660515_B2533FBA)
References: <20160713114449.24665-1-yanivma@ti.com>
	 (sfid-20160713_134104_660515_B2533FBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-13 at 14:44 +0300, Yaniv Machani wrote:
> From: Maital Hahn <maitalm@ti.com>
> 
> Some drivers (e.g. wl18xx) expect that the last stage in the
> de-initialization process will be stopping the beacons, similar to AP
> flow.
> Update ieee80211_stop_mesh() flow accordingly.
> As peers can be removed dynamically, this would not impact other
> drivers.
> 
Ah, I see now that you did :)

johannes
