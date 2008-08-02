Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38997
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbYHBFQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 01:16:04 -0400
Date: Fri, 01 Aug 2008 22:16:04 -0700 (PDT)
Message-Id: <20080801.221604.149076257.davem@davemloft.net> (sfid-20080802_071611_183960_F8591CD4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080801205830.GA10071@tuxdriver.com>
References: <20080801205830.GA10071@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Aug 2008 16:58:30 -0400

> Another big batch of wireless fixes for 2.6.27.  The ath5k series is
> more than fixes, but I included it because it enables new ath5k
> hardware.  (The ath5k.h changes in particular are documentation cleanups
> for registers based on info gleaned from the newly posted ath9k driver.)
> The others patches are fixes, some more obvious than others. :-)
> 
> Let me know if there are any problems!

Pulled and pushed out to net-2.6 on kernel.org

If someone could fix up this warning I'd appreciate it:

drivers/net/wireless/rt2x00/rt73usb.c: In function 'rt73usb_load_firmware':
drivers/net/wireless/rt2x00/rt73usb.c:916: warning: passing argument 5 of 'rt2x00usb_vendor_request_large_buff' discards qualifiers from pointer target type

Thanks.
