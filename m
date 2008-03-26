Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758563AbYCZXLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 19:11:35 -0400
Date: Wed, 26 Mar 2008 16:11:35 -0700 (PDT)
Message-Id: <20080326.161135.92926153.davem@davemloft.net> (sfid-20080326_231209_469581_507F8104)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-03-24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080324234951.GA8712@tuxdriver.com>
References: <20080324234951.GA8712@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 24 Mar 2008 19:49:51 -0400

> Here is today's round of fixes for 2.6.25.  Most of them are one-liners,
> including a few typos, a couple of warning fixes, and a new USB ID for
> rt73.  The only one of much size is a b43 fix relating to the hacks
> used to overcome the limitations of its DMA hardware.  Overall, I don't
> think there is anything controversial this time around.

Pulled and pushed out to net-2.6, thanks!

I'll try to get this merged into net-2.6.26 before the
weekend.
