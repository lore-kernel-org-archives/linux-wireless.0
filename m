Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761373Ab2COOrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:47:16 -0400
Subject: Re: [PATCH] rndis_wlan: don't report station signal
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20120315142527.GC31717@tuxdriver.com>
References: <1331820805.3432.17.camel@jlt3.sipsolutions.net>
	 <20120315142527.GC31717@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 15:47:14 +0100
Message-ID: <1331822834.3432.22.camel@jlt3.sipsolutions.net> (sfid-20120315_154728_041264_A1BCBDC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 10:25 -0400, John W. Linville wrote:
> On Thu, Mar 15, 2012 at 03:13:25PM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The station signal value is supposed to be in dBm
> > which the device can't give, so don't report it.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Won't this break functionality for users of this device?

I don't know if it breaks functionality, but filling in values in the
wrong units doesn't seem like a good plan.

johannes

