Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58731 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbCJPtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:49:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Date: Tue, 10 Mar 2015 16:48:31 +0100
Message-ID: <2300824.dcEMS7aYJa@wuerfel> (sfid-20150310_164923_326470_BC0B83A7)
In-Reply-To: <20150310142805.GN5264@atomide.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <2223973.a64rBcZvaA@wuerfel> <20150310142805.GN5264@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 March 2015 07:28:05 Tony Lindgren wrote:
> 
> Oops I forgot about the omap3-sbc-t3730, so yes we have to keep the
> platform data a little bit longer. But nothing stopping us moving
> all the other ones to use a proper device tree based configuration.
> 

For all I can tell, the t3730 board file does not support wl12xx
at the moment, only the dts file does.

If we do what Sekhar suggested and drop wl12xx support from
the DA850 EVM board file, we can fix all wlcore users.

	Arnd
