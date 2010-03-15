Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:51776 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965750Ab0COTWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 15:22:53 -0400
Message-ID: <4B9E890C.6010906@gmail.com>
Date: Mon, 15 Mar 2010 20:22:52 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Alban Browaeys <prahal@yahoo.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: txdone implementation supporting hw encryption.
References: <4B871EA6.9050105@yahoo.com> <20100315185654.GB2974@tuxdriver.com>
In-Reply-To: <20100315185654.GB2974@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/10 19:56, John W. Linville wrote:
> On Fri, Feb 26, 2010 at 02:06:46AM +0100, Alban Browaeys wrote:
>> This is an implementation that support WCID being the encryption key.
>> Wireless Cli Id was set to be the encryption key in rt2800pci_write_tx_desc
>> and read (TX_STA_FIFO_WCID) as the current queue entry index.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> 
> /home/linville/git/wireless-testing
> [linville-t400.local]:> patch -p1 < rt2x00.patch
> patching file drivers/net/wireless/rt2x00/rt2800pci.c
> Hunk #1 FAILED at 907.
> Hunk #2 FAILED at 936.
> Hunk #3 FAILED at 997.
> 3 out of 3 hunks FAILED -- saving rejects to file drivers/net/wireless/rt2x00/rt2800pci.c.rej
> 
> Would you care to post a version that applies against the current
> wireless-testing?
> 

John,

If you want, you can also pull from:

git://git.gwingerde.nl/rt2x00-next-2.6.git

This contains all rt2x00 patches sent to the list (and you) that were acked by either Ivo or myself, or both.
This tree is against wireless-next-2.6, but should do the trick, I guess.

---
Gertjan.
