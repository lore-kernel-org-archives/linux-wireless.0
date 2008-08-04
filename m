Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55076
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYHDWBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 18:01:50 -0400
Date: Mon, 04 Aug 2008 15:01:47 -0700 (PDT)
Message-Id: <20080804.150147.78586437.davem@davemloft.net> (sfid-20080805_000203_667354_A05515A2)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804193753.GA30345@tuxdriver.com>
References: <20080804193753.GA30345@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 4 Aug 2008 15:37:53 -0400

> Another big round of fixes for 2.6.27.  Included is also a renaming
> patch and some related patches that rename iwl4965 to iwlagn (reflecting
> that is supports iwl5000 as well).
> 
> The other big(ger) thing here is the new ath9k driver.  It is probably
> still far from perfect, but I'm hearing good reports on its
> functionality and the Atheros team (and others) have already been quite
> responsive on comments, etc.  I think it is best to go ahead and get it
> into 2.6.27.
> 
> Please let me know if there are problems!

I'm holding off on this pull until the list.h changes get so me lkml
ACKs.

