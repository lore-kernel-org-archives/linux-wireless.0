Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:48620 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbZLRWJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 17:09:42 -0500
Subject: Re: [PATCH] ps3_gelic_wireless: Fix build failure due to missing
 WEXT_PRIV
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>
References: <1261115574.2173.18.camel@pasglop>
	 <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Dec 2009 09:09:11 +1100
Message-ID: <1261174151.2173.66.camel@pasglop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-12-18 at 08:55 -0800, Randy Dunlap wrote:
> 
> Probably also needs
>         depends on WLAN
> to prevent build failures.

Yeah, GELIC_WIRELESS should probably. I'll do a separate patch next week
but feel free to beat me to it.

Cheers,
Ben.


