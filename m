Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57354 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0BTJEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 04:04:04 -0500
Date: Sat, 20 Feb 2010 10:03:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] mwl8k: convert to new station add/remove callbacks
Message-ID: <20100220090345.GK1637@mail.wantstofly.org>
References: <20100219180652.409890561@sipsolutions.net> <20100219180737.156138399@sipsolutions.net> <1266603517.10689.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266603517.10689.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 07:18:37PM +0100, Johannes Berg wrote:

> This converts mwl8k to use the new station
> add/remove callbacks instead of using the
> old sta_notify callback.
> 
> The new callbacks can sleep, so a lot of
> code can be removed now.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
