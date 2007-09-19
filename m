Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40401
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbXISWIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 18:08:36 -0400
Date: Wed, 19 Sep 2007 15:08:35 -0700 (PDT)
Message-Id: <20070919.150835.35013628.davem@davemloft.net>
To: jeff@garzik.org
Cc: linville@tuxdriver.com, hch@infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: Please pull 'p54' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F19C3C.6090605@garzik.org>
References: <20070919.141200.56568833.davem@davemloft.net>
	<20070919212607.GA3036@tuxdriver.com>
	<46F19C3C.6090605@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 19 Sep 2007 18:01:32 -0400

> There were complaints about the nonsensical wireless/mac80211
> directory.  But if there are enough files, a driver should
> definitely get its own directory.  Like life, it's a balance.  If
> it's just one or two C files, a directory might be overkill.  If
> it's more, it definitely warrants a sub-dir.

That's generally how I see things too.
