Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56671 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab0FRQjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 12:39:52 -0400
Subject: Re: USB device that supports master mode?
From: Pavel Roskin <proski@gnu.org>
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Cc: Robert Urban <urban@unix-beratung.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1276871717.918.1.camel@gnutoo-laptop>
References: <4C0EDB71.1070104@unix-beratung.de>
	 <1276871717.918.1.camel@gnutoo-laptop>
Content-Type: text/plain
Date: Fri, 18 Jun 2010 12:39:49 -0400
Message-Id: <1276879189.5110.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-18 at 16:35 +0200, Denis 'GNUtoo' Carikli wrote:
> On Wed, 2010-06-09 at 02:08 +0200, Robert Urban wrote:
> > Hello Wireless folks,
> > 
> > I'm looking for a USB device that supports master mode, preferably with a
> > connection for an external antenna.
> > 
> > Does anyone know of specific products that satisy these criteria?
> > 
> > thanks,
> > 
> > Rob Urban
> I've a rt3070 that can do access point,
> I've tried it with wireless-compat and it worked.
> But I've not used it extensively(I plan to do so altough because of the
> good range.)
> It also has a connector for the antenna,but I don't know the brand,
> there is no brand written on it.

TP-Link TL-WN422G has an external antenna, it's a USB device and it
supports master mode with the patches for ath9k_htc that were recently
posted:

http://marc.info/?t=127676699200001&r=1&w=3

The device appears to be capable of 802.11n, even though that capability
is not advertised on the box.  I haven't run any benchmarks though.

-- 
Regards,
Pavel Roskin
