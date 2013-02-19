Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54229 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3BSFwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 00:52:08 -0500
Date: Tue, 19 Feb 2013 00:52:06 -0500 (EST)
Message-Id: <20130219.005206.397289032011003833.davem@davemloft.net> (sfid-20130219_065213_829241_34929596)
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, bittorf@bluebottle.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Feb 2013 21:01:20 -0600

> Bastian Bittorf reported that some of the silent freezes on a Linksys WRT54G
> were due to overflow of the RX DMA ring buffer, which was created with 64
> slots. That finding reminded me that I was seeing similar crashed on a netbook,
> which also has a relatively slow processor. After increasing the number of
> slots to 128, runs on the netbook that previously failed now worked; however,
> I found that 109 slots had been used in one test. For that reason, the number
> of slots is being increased to 256.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Applied.
