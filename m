Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48374 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab0GUR7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:59:36 -0400
Date: Wed, 21 Jul 2010 18:59:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>, linux@arm.linux.org.uk,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 10/20] omap: zoom: add fixed regulator device for
	wlan
Message-ID: <20100721175930.GD10930@sirena.org.uk>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com> <1279733634-21974-11-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279733634-21974-11-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 08:33:44PM +0300, Ohad Ben-Cohen wrote:

> +static struct regulator_consumer_supply zoom_vmmc3_supply = {
> +	.supply		= "vmmc",
> +};

This looks like a misconfiguration on the consumer - I'd strongly expect
the consumer to have a dev_name specified also with the name being in
terms of the consumer device.
