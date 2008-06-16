Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57895
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756704AbYFPJVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 05:21:03 -0400
Date: Mon, 16 Jun 2008 02:21:04 -0700 (PDT)
Message-Id: <20080616.022104.217167562.davem@davemloft.net> (sfid-20080616_112109_240324_58B38EF3)
To: mokuno@sm.sony.co.jp
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12]: Proper compat WEXT support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080616174509.B048.40F06B3A@sm.sony.co.jp>
References: <20080604184955.B033.40F06B3A@sm.sony.co.jp>
	<20080612.225332.193703791.davem@davemloft.net>
	<20080616174509.B048.40F06B3A@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date: Mon, 16 Jun 2008 18:15:12 +0900

> With this new patch #12, it worked OK for me.   I tested on my PS3 with:
> 
>   - wireless_tools version 28 and 29.  Both 64 and 32-bit compiled
>     iwlist and iwconfig
>   - wpa_supplicant 0.6.x, 64 and 32-bit compiled
>   - gelic and zd1211 driver
>   
> 
> checkpatch.pl complained some error/warnings on the patches #7, #9 and
> #12.  It seemed that most of them were inherited from the original code,
> some seemed like newly created ones, like 80-characters over warnings in
> net/mac80211/mlme.c.  We might want to fix them?
> 
> Anyway the code works fine.  Again, thank you!

Thank you very much for testing.

I will respin my tree and look into the checkpatch warnings
so that I may make a final submission to John Linville.

Arigato gozaimasu!!
