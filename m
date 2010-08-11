Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55279 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0HKQBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 12:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <4C6275F3.6030108@nokia.com>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
	<1281478348-24833-9-git-send-email-ohad@wizery.com> <4C6275F3.6030108@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 11 Aug 2010 19:01:20 +0300
Message-ID: <AANLkTinYn2NQFeS8GocmTgU20Cc24Ax+RSbMLGz3KGom@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] omap: hsmmc: split mmc23 power control
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 11, 2010 at 1:05 PM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
> Ohad Ben-Cohen wrote:
>>
>> Prepare for mmc3 regulator power control by splitting the power
>> control functions of mmc2 and mmc3, and expecting mmc3 to have
>> a single, dedicated, regulator support.
>
> Why?  Can't the controller be connected to an eMMC with 2 power
> supplies?  At a glance, it is not obvious why this patch is needed.

I had ZOOM too much in mind when I did that. Removed now, thanks !
