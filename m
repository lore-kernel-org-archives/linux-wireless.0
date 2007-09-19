Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57894
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbXISS7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:59:05 -0400
Date: Wed, 19 Sep 2007 11:59:03 -0700 (PDT)
Message-Id: <20070919.115903.75429061.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070919181005.GB5483@tuxdriver.com>
References: <20070919181005.GB5483@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 19 Sep 2007 14:10:05 -0400

> This patch adds z1211 (previously known as zd1211rw-mac80211),
> a driver for Zydas ZD1211 hardware.  This driver has proven very
> robust -- Fedora 7 uses this driver and I don't think I have any open
> bugzillas for it.  Either the driver works well, or no one as using
> it...given the common availability of the hardware, I have to presume
> the former. :-)
> 
> This driver is mostly a port of zd1211rw to the mac80211
> infrastructure.  In fact, most zd1211rw patches have been mirrored
> directly to this driver for some time.  I considered merely updating
> the existing driver with this code, but I think it is more prudent to
> include this as a separate driver just to avoid confusion.  There is
> some symbol clash between the two drivers, so I add a Kconfig hack
> to ensure that only one or the other is built-in or that this one is
> built as a module.
> 
> The maintainers have identified some (IMHO minor) issues with the
> mac80211 port of this driver.  Some of them are summarized here:
> 
> 	http://linuxwireless.org/en/users/Drivers/zd1211rw/mac80211Issues
> 
> Still, I think we would be better-off having this driver upstream.

Agreed, merged into net-2.6.24, thanks John.
