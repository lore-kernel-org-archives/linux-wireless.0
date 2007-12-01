Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:59491 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbXLAKdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2007 05:33:51 -0500
Date: Sat, 1 Dec 2007 11:33:50 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>,
	David Miller <davem@davemloft.net>, dsd@gentoo.org
Subject: Re: ZD1211RW unaligned accesses...
Message-ID: <20071201103350.GB25387@deine-taler.de> (sfid-20071201_103404_750352_A22BE5FC)
References: <20071120.040546.222294375.davem@davemloft.net> <47442BFC.8090008@hotmail.com> <20071124150216.GA28153@gondor.apana.org.au> <20071129214533.GD32730@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071129214533.GD32730@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:

> So, did the patch below fix the problem?  Should I apply it?
> 
> John

John,

the patch would have worked, but I have sent a second one to the
list, which is based on Herbert's and has an assert to be able to test
the patch on x86.

You should be notify that the mac80211 driver, doesn't suffer
from the problem and Daniel has already provided a patch to
replace zd1211rw by the mac80211 driver. Daniel's patch must of
course break by the new patch.

-- 
Uli Kunitz
