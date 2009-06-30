Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40637 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZF3Tpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 15:45:51 -0400
Date: Tue, 30 Jun 2009 15:39:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
	staging/wlan-ng driver.
Message-ID: <20090630193930.GD2722@tuxdriver.com>
References: <1246388712.4949.52.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1246388712.4949.52.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 08:05:12PM +0100, Karl Relton wrote:

> +
> +--------------------------------------------------------------------------
> +
> +Driver: staging/wlan-ng - prism 2/3 usb 802.11 wireless lan adapters
> +
> +File: prism2_ru.hex
> +
> +License:
> +
> +The following binary firmware files are (c) Conexant, and do not fall
> +under the GPL or MPL.  They are assumed to have the same license as
> +their windows client drivers, ie everyone who bought a card that came
> +with a windows driver already has a copy of and license to use the
> +necessary firmware, albeit possibly an older version.  These were bundled
> +with linux-wlan-ng for convenience only, as many newer adapters 
> +(eg Prism 3 w/SSF) require a firmware download in order to function at 
> +all.
> +
> +As far as is known, the last copyright holder of these  
> +binaries was Conexant and that they were freely distributed.

Is this really good enough?  What is the difference between the above
and cutting firmware images out of the (freely distributed) Broadcom
drivers for Windows?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
