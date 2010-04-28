Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60701
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab0D1VXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:23:18 -0400
Date: Wed, 28 Apr 2010 14:23:23 -0700 (PDT)
Message-Id: <20100428.142323.91321737.davem@davemloft.net>
To: hauke@hauke-m.de
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-04-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BD8A6B4.20603@hauke-m.de>
References: <20100415200331.GD3020@tuxdriver.com>
	<20100415.142907.68448693.davem@davemloft.net>
	<4BD8A6B4.20603@hauke-m.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed, 28 Apr 2010 23:20:52 +0200

> Hi David,
> 
> in your merge in 5c01d5669356e13f0fb468944c1dd4c6a7e978ad you added "int
> i;" into wl1271_main.c which is unused in that function.
> 
> This patch fixes the merge problem:
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks.
