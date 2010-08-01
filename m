Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51969 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0HASEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 14:04:45 -0400
Subject: Re: [PATCH 05/11] pcmcia: do not use io_req_t when calling
 pcmcia_request_io()
From: Marcel Holtmann <marcel@holtmann.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, laforge@gnumonks.org,
	linux-mtd@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-serial@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <1280667550-3040-5-git-send-email-linux@dominikbrodowski.net>
References: <20100801125749.GA2564@comet.dominikbrodowski.net>
	 <1280667550-3040-5-git-send-email-linux@dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 11:04:37 -0700
Message-ID: <1280685877.12579.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dominik,

> Instead of io_req_t, drivers are now requested to fill out
> struct pcmcia_device *p_dev->resource[0,1] for up to two ioport
> ranges. After a call to pcmcia_request_io(), the ports found there
> are reserved, after calling pcmcia_request_configuration(), they may
> be used.
> 
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-ide@vger.kernel.org
> CC: linux-usb@vger.kernel.org
> CC: laforge@gnumonks.org
> CC: linux-mtd@lists.infradead.org
> CC: linux-bluetooth@vger.kernel.org
> CC: alsa-devel@alsa-project.org
> CC: linux-serial@vger.kernel.org
> CC: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

for the drivers/bluetooth/ pieces.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


