Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42210
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbXEGIjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 04:39:47 -0400
Date: Mon, 07 May 2007 01:39:50 -0700 (PDT)
Message-Id: <20070507.013950.39156872.davem@davemloft.net>
To: hch@infradead.org
Cc: flamingice@sourmilk.net, linville@tuxdriver.com, jeff@garzik.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	andrea.merello@gmail.com
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070507081531.GA28498@infradead.org>
References: <20070507073636.4232.93444.stgit@panda.sourmilk.net>
	<200705070346.17868.flamingice@sourmilk.net>
	<20070507081531.GA28498@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 7 May 2007 09:15:31 +0100

> On Mon, May 07, 2007 at 03:46:17AM -0400, Michael Wu wrote:
> > This patch adds a mac80211 based wireless driver for the rtl8187 USB
> > wireless card.
> > 
> > Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> > ---
> > 
> >  MAINTAINERS                                        |   10 
> >  drivers/net/wireless/Kconfig                       |    2 
> >  drivers/net/wireless/Makefile                      |    3 
> >  drivers/net/wireless/mac80211/Kconfig              |    1 
> >  drivers/net/wireless/mac80211/Makefile             |    1 
> >  drivers/net/wireless/mac80211/rtl818x/Kconfig      |   16 
> >  drivers/net/wireless/mac80211/rtl818x/Makefile     |    2 
> >  drivers/net/wireless/mac80211/rtl818x/rtl8187.h    |  125 +++
> >
> 
> Driver shouldn't be in another useless sub-hiearchay just because
> of some common code they use.

Agreed.
