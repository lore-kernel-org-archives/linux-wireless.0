Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45733 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161492AbXDWTi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 15:38:26 -0400
Date: Mon, 23 Apr 2007 21:35:19 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] refactor wireless Kconfig
Message-ID: <20070423213519.2692d0fd@localhost>
In-Reply-To: <20070423183443.GD5883@tuxdriver.com>
References: <20070423183334.GC5883@tuxdriver.com>
	<20070423183443.GD5883@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Apr 2007 14:34:43 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> -comment "Obsolete Wireless cards support (pre-802.11)"
> -	depends on NET_RADIO && (INET || ISA || PCMCIA)
> +	  This option does not affect the kernel build, it only
> +	  let's you choose drivers.
          ^^^^^

> +config WLAN_80211
> +	bool "Wireless LAN (IEEE 802.11)"
> +	depends on NETDEVICES
> +	---help---
> +	  Say Y if you have any 802.11 wireless LAN hardware.
> +
> +	  This option does not affect the kernel build, it only
> +	  let's you choose drivers.
          ^^^^^

--
Ciao
Stefano
