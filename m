Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34690 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0IPS7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:59:39 -0400
Date: Thu, 16 Sep 2010 14:45:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Filter ProbeReq SuppRates based on TX rate mask
Message-ID: <20100916184557.GD7221@tuxdriver.com>
References: <20100828163610.GA23426@jm.kir.nu>
 <1283154490.3691.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283154490.3691.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 09:48:10AM +0200, Johannes Berg wrote:
> On Sat, 2010-08-28 at 19:36 +0300, Jouni Malinen wrote:
> > If the TX rate set has been masked, the removed rates can also be
> > removed from the Supported Rates and Extended Supported Rates IEs in
> > Probe Request frames.
> 
> Technically, the probe request frame indicates RX bitrates. I don't
> really mind using the TX bitrates as well since typically I do think you
> probably want them to be symmetric, but shouldn't that come with nl80211
> updates etc. since that's all saying TX_BITRATES?

Ping?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
