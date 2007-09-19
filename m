Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXISVES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:04:18 -0400
Date: Wed, 19 Sep 2007 22:04:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Please pull 'p54' branch of wireless-2.6
Message-ID: <20070919210405.GA2231@infradead.org>
References: <20070919195527.GD5483@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070919195527.GD5483@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 03:55:27PM -0400, John W. Linville wrote:
>  drivers/net/wireless/Kconfig     |   13 +
>  drivers/net/wireless/Makefile    |    4 +
>  drivers/net/wireless/net2280.h   |  452 +++++++++++++++++
>  drivers/net/wireless/p54.h       |   80 +++
>  drivers/net/wireless/p54common.c |  983 ++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/p54common.h |  329 +++++++++++++
>  drivers/net/wireless/p54pci.c    |  689 ++++++++++++++++++++++++++
>  drivers/net/wireless/p54pci.h    |  106 ++++
>  drivers/net/wireless/p54usb.c    |  904 +++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/p54usb.h    |  133 +++++

PLease put it into a separate subdirectory, thanks.

Also net2280.h seems rather oddly named.

