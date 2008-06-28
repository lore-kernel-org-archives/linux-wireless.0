Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48675
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbYF1I3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 04:29:12 -0400
Date: Sat, 28 Jun 2008 01:29:12 -0700 (PDT)
Message-Id: <20080628.012912.03104549.davem@davemloft.net> (sfid-20080628_102944_853155_7864D88E)
To: linville@tuxdriver.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: pending wireless/wireless-current merge conflict
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080625180430.GA13730@tuxdriver.com>
References: <20080613215601.GA8345@tuxdriver.com>
	<20080625180430.GA13730@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 25 Jun 2008 14:04:30 -0400

> I just sent a pull request for Dave that will result in nasty-looking
> conflict in iwl4965-base.c.  I have a sample merge available here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 merge-test
> 
> The overview of the resolution is to ignore any changes in
> iwl4965-base.c and take drivers/net/wireless/iwlwifi/iwl-scan.c from
> the URL above.

I've just merged net-2.6 into net-next-2.6 and done my best to
resolve that merge.

Thanks for the heads up!

