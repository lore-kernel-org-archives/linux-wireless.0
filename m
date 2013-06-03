Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50752 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3FCTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 15:15:08 -0400
Date: Mon, 3 Jun 2013 15:04:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: TI wireless drivers fixes 2013-06-03 (for 3.10)
Message-ID: <20130603190451.GF2727@tuxdriver.com> (sfid-20130603_211511_615962_6CB6FC54)
References: <1370259433.31905.7.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370259433.31905.7.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 02:37:13PM +0300, Luciano Coelho wrote:
> Hi John,
> 
> Here are three patches that I'd like to get into 3.10.  Two of them, by
> me, are related to the firmware version checks in our driver.  Without
> them, the firmwares fail to load.  The other one, by Eliad, fixes a typo
> bug in our 5GHz scanning code.
> 
> Please let me know if you have any problems with it!
> 
> The following changes since commit 4ab21db2202895e2c9d3520fed8e7fb061b29605:
> 
>   rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1) networks (2013-05-31 13:00:33 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wl12xx-fixes
> 
> for you to fetch changes up to 1b5346776c6688006380c2bb491ebf28bc3f3a19:
> 
>   wl12xx/wl18xx: scan all 5ghz channels (2013-06-03 11:43:41 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
