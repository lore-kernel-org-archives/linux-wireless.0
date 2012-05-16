Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2EPFH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 01:07:27 -0400
Date: Wed, 16 May 2012 01:06:20 -0400 (EDT)
Message-Id: <20120516.010620.1217035745038191380.davem@davemloft.net> (sfid-20120516_070744_564871_353DCAD1)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-05-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120515205157.GF24572@tuxdriver.com>
References: <20120515205157.GF24572@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 15 May 2012 16:51:58 -0400

> Here are three more fixes that some of my developers are desperate to
> see included in 3.4...
> 
> Johan Hedberg went to some length justifyng the inclusion of these two
> Bluetooth fixes:
> 
> "The device_connected fix should be quite self-explanatory, but it's
> actually a wider issue than just for keyboards. All profiles that do
> incoming connection authorization (e.g. headsets) will break without it
> with specific hardware. The reason it wasn't caught earlier is that it
> only occurs with specific Bluetooth adapters.
> 
> As for the security level patch, this fixes L2CAP socket based security
> level elevation during a connection. The HID profile needs this (for
> keyboards) and it is the only way to achieve the security level
> elevation when using the management interface to talk to the kernel
> (hence the management enabling patch being the one that exposes this"
> 
> The rtlwifi fix addresses a regression related to firmware loading,
> as described in kernel.org bug 43187.  It basically just moves a hunk
> of code to a more appropriate place.

Pulled, and the above text gave me something to put into the merge
commit log message, thanks :-)
