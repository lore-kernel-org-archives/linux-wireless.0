Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:56820 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZDVVIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 17:08:30 -0400
Message-ID: <20090423000820.82452fzhxxsz1c8w@hayate.sektori.org> (sfid-20090422_230833_882876_B4EF9651)
Date: Thu, 23 Apr 2009 00:08:20 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 22 (rndis_wlan)
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
	<49EF4B73.2050702@oracle.com> <20090422172804.GE3288@tuxdriver.com>
In-Reply-To: <20090422172804.GE3288@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

>> # CONFIG_CFG80211 is not set
>
> No doubt this is the problem...
>
> ---
>
> From bce85c97aeeb9c34098951e9ef3de425c6830b63 Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Wed, 22 Apr 2009 13:27:08 -0400
> Subject: [PATCH] rndis_wlan: select CFG80211 in Kconfig
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


