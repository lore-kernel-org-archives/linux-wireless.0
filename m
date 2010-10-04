Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0JDTdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:33:08 -0400
Subject: Re: [PATCH 0/4] nl80211 cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20101004191402.183055479@sipsolutions.net>
References: <20101004191402.183055479@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:33:07 +0200
Message-ID: <1286220787.3620.58.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 21:14 +0200, Johannes Berg wrote:
> This patchset adds some new hooks to generic
> netlink and then goes on to use them to really
> optimise a lot of locking code in nl80211.
> 
> It not only shrinks the code in nl80211 by     
> almost 5K .text, but also greatly reduces the
> likelihood of future errors.

And by that, I mean locking errors.

johannes

