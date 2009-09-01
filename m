Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48139 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZIANaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:30:23 -0400
Date: Tue, 1 Sep 2009 09:18:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/19] wireless: convert drivers to netdev_tx_t
Message-ID: <20090901131817.GB7650@tuxdriver.com>
References: <20090901055039.824876937@vyatta.com> <20090901055130.266010870@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090901055130.266010870@vyatta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 10:50:57PM -0700, Stephen Hemminger wrote:
> Mostly just simple conversions:
>   * ray_cs had bogus return of NET_TX_LOCKED but driver
>     was not using NETIF_F_LLTX
>   * hostap and ipw2x00 had some code that returned value
>     from a called function that also had to change to return netdev_tx_t
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
