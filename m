Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:13541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbbFXGSD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 02:18:03 -0400
Message-ID: <558A4C21.3060906@intel.com> (sfid-20150624_081826_332511_E8077C05)
Date: Wed, 24 Jun 2015 09:20:17 +0300
From: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Charles Gorand <charles.gorand@effinnov.com>
CC: linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] NFC: nxp-nci_i2c: use flags argument of devm_gpiod_get_index
References: <1434532252-29485-1-git-send-email-u.kleine-koenig@pengutronix.de> <20150623123044.GH13739@pengutronix.de>
In-Reply-To: <20150623123044.GH13739@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Uwe,

On 06/23/2015 03:30 PM, Uwe Kleine-König wrote:
>> Note this patch depends on
>> 551e306905ef (NFC: nxp-nci_i2c: Add support for enumerating through ACPI)
>> which only appeared in today's next.
> This still applies. So an ack would be very welcome.

Your changes look fine. Thanks for updating the driver. And sorry for the delay.

Regards,
Oleg
