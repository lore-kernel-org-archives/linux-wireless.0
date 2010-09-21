Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:24105 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0IUFuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 01:50:04 -0400
Subject: Re: [PATCH v6 4/7] wl1271: take irq info from private board data
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1284593495-30012-1-git-send-email-ohad@wizery.com>
References: <1284593495-30012-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:38:57 +0300
Message-ID: <1285047537.17849.12.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 01:31 +0200, ext Ohad Ben-Cohen wrote:
> Remove the hard coded irq information, and instead take
> the irq information from the board's platform data.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

