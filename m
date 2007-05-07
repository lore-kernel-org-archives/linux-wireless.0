Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4179 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965540AbXEGQDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 12:03:20 -0400
Date: Mon, 7 May 2007 11:34:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Message-ID: <20070507153450.GC5125@tuxdriver.com>
References: <200705070346.04982.flamingice@sourmilk.net> <20070507142715.GB32546@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070507142715.GB32546@fluff.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2007 at 02:27:15PM +0000, Ben Dooks wrote:
> On Mon, May 07, 2007 at 03:46:04AM -0400, Michael Wu wrote:
> > From: Ivo van Doorn <ivdoorn@gmail.com>
> > 
> > This patch adds a library for reading from and writing to 93cx6 eeproms.
> 
> This looks remarkably like an SPI device, why not use the
> spi framework to drive this?

This isn't intended to be a user-visible device.  Rather, it
is a support library for internal use by drivers to read hardware
configuration info, etc.  Given that, do we really need something as
heavy as implementing an SPI master, etc?

John
-- 
John W. Linville
linville@tuxdriver.com
