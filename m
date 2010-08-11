Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:45355 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0HKKwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 06:52:24 -0400
Message-ID: <4C6280DA.70205@nokia.com>
Date: Wed, 11 Aug 2010 13:52:10 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v3 8/9] omap: hsmmc: split mmc23 power control
References: <1281478348-24833-1-git-send-email-ohad@wizery.com> <1281478348-24833-9-git-send-email-ohad@wizery.com> <4C6275F3.6030108@nokia.com>
In-Reply-To: <4C6275F3.6030108@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2010 01:05 PM, Hunter Adrian (Nokia-MS/Helsinki) wrote:
> Ohad Ben-Cohen wrote:
>> Prepare for mmc3 regulator power control by splitting the power
>> control functions of mmc2 and mmc3, and expecting mmc3 to have
>> a single, dedicated, regulator support.
>
> Why?  Can't the controller be connected to an eMMC with 2 power
> supplies?  At a glance, it is not obvious why this patch is needed.
>
I agree with Adrian. This patch is not required at all.
