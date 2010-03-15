Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39180 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965680Ab0COTAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 15:00:46 -0400
Date: Mon, 15 Mar 2010 14:56:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alban Browaeys <prahal@yahoo.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: txdone implementation supporting hw encryption.
Message-ID: <20100315185654.GB2974@tuxdriver.com>
References: <4B871EA6.9050105@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B871EA6.9050105@yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2010 at 02:06:46AM +0100, Alban Browaeys wrote:
> This is an implementation that support WCID being the encryption key.
> Wireless Cli Id was set to be the encryption key in rt2800pci_write_tx_desc
> and read (TX_STA_FIFO_WCID) as the current queue entry index.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>

/home/linville/git/wireless-testing
[linville-t400.local]:> patch -p1 < rt2x00.patch
patching file drivers/net/wireless/rt2x00/rt2800pci.c
Hunk #1 FAILED at 907.
Hunk #2 FAILED at 936.
Hunk #3 FAILED at 997.
3 out of 3 hunks FAILED -- saving rejects to file drivers/net/wireless/rt2x00/rt2800pci.c.rej

Would you care to post a version that applies against the current
wireless-testing?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
