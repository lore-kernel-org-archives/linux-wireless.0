Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62537 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab0HKUJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 16:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik8yftwy9Toq473134vcdoFN1Z29oTc9MGEUzue@mail.gmail.com>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
	<1281478348-24833-10-git-send-email-ohad@wizery.com>
	<4C626140.3080107@nokia.com>
	<AANLkTik8yftwy9Toq473134vcdoFN1Z29oTc9MGEUzue@mail.gmail.com>
Date: Thu, 12 Aug 2010 01:39:38 +0530
Message-ID: <AANLkTi=n=uH5ePRf8KzXWTtSdyRabpOCOgLBSD1GfwkJ@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] omap: zoom: add mmc3/wl1271 device support
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Roger Quadros <roger.quadros@nokia.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad,

On Wed, Aug 11, 2010 at 9:08 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Aug 11, 2010 at 11:37 AM, Roger Quadros <roger.quadros@nokia.com> wrote:
>>> +               .ocr_mask       = MMC_VDD_165_195,
>>
>> Do we really need to specify ocr_mask here?

Since you specified the voltage source is fixed, and if MMC3 has any
dedicated regulator as MMC1 & MMC2 you can go with
Roger's comments.
If the LDO is fixed voltage source from TWL then since regulator
framework supports only adjustable LDO's, I think you can
have ocr_mask defined as above in board file.

Regards,
Kishore
>
> Removed, thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
