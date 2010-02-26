Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53304 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966484Ab0BZWvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 17:51:55 -0500
Message-ID: <4B885089.6040605@gmail.com>
Date: Fri, 26 Feb 2010 23:51:53 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: prahal@yahoo.com
CC: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: txdone implementation supporting hw encryption.
References: <4B88490F.7030605@yahoo.com>
In-Reply-To: <4B88490F.7030605@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/10 23:19, Alban Browaeys wrote:
> This is an implementation that support WCID being the encryption key.
> Wireless Cli Id was set to be the encryption key in rt2800pci_write_tx_desc
> and read (TX_STA_FIFO_WCID) as the current queue entry index.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

