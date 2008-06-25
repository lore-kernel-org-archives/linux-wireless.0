Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3146 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYFYSQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 14:16:58 -0400
Date: Wed, 25 Jun 2008 14:04:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: linux-next: pending wireless/wireless-current merge conflict
Message-ID: <20080625180430.GA13730@tuxdriver.com> (sfid-20080625_201710_623694_277EBFE4)
References: <20080613215601.GA8345@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080613215601.GA8345@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just sent a pull request for Dave that will result in nasty-looking
conflict in iwl4965-base.c.  I have a sample merge available here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 merge-test

The overview of the resolution is to ignore any changes in
iwl4965-base.c and take drivers/net/wireless/iwlwifi/iwl-scan.c from
the URL above.

Just a heads-up... :-)

John

P.S.  Hopefully the iwlwifi guys will double check the accuracy of
my fix-up...
-- 
John W. Linville
linville@tuxdriver.com
