Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3AUVEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 16:04:08 -0500
Date: Mon, 21 Jan 2013 16:04:04 -0500 (EST)
Message-Id: <20130121.160404.1007504714461228602.davem@davemloft.net> (sfid-20130121_220423_938097_2301D37C)
To: mcgrof@do-not-panic.com
Cc: sgruszka@redhat.com, bhutchings@solarflare.com,
	netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, mirqus@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAB=NE6XjvupJ5XO0EN0HVwdy61ECWL=Ey0g1gsNm+v8Sen=nsQ@mail.gmail.com>
References: <1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com>
	<20130111.155936.1799008114956712424.davem@davemloft.net>
	<CAB=NE6XjvupJ5XO0EN0HVwdy61ECWL=Ey0g1gsNm+v8Sen=nsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


It's queued up for -stable already as is clearly seen at:

http://patchwork.ozlabs.org/user/bundle/2566/?state=*
