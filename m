Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37632 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbFXHDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 03:03:24 -0400
Date: Wed, 24 Jun 2015 09:03:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Charles Gorand <charles.gorand@effinnov.com>,
	linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] NFC: nxp-nci_i2c: use flags argument of
 devm_gpiod_get_index
Message-ID: <20150624070312.GK13739@pengutronix.de> (sfid-20150624_090331_624356_CD824C2B)
References: <1434532252-29485-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20150623123044.GH13739@pengutronix.de>
 <558A4C21.3060906@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <558A4C21.3060906@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Oleg,

On Wed, Jun 24, 2015 at 09:20:17AM +0300, Oleg Zhurakivskyy wrote:
> On 06/23/2015 03:30 PM, Uwe Kleine-König wrote:
> >> Note this patch depends on
> >> 551e306905ef (NFC: nxp-nci_i2c: Add support for enumerating through ACPI)
> >> which only appeared in today's next.
> > This still applies. So an ack would be very welcome.
> 
> Your changes look fine. Thanks for updating the driver. And sorry for the delay.
I interpret this as an ack, and assuming the patch won't make it in for
4.2-rc1 via nfc I'll send it to Linus Walleij together with the gpiod
change.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
