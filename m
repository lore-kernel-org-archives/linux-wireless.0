Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45142 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab0HKUSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 16:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTin9ABch+_S=gYwD2HKPm8aT8etwfsE_WRRoq=2U@mail.gmail.com>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
	<1281478348-24833-10-git-send-email-ohad@wizery.com>
	<4C626140.3080107@nokia.com>
	<AANLkTik8yftwy9Toq473134vcdoFN1Z29oTc9MGEUzue@mail.gmail.com>
	<AANLkTi=n=uH5ePRf8KzXWTtSdyRabpOCOgLBSD1GfwkJ@mail.gmail.com>
	<AANLkTin9ABch+_S=gYwD2HKPm8aT8etwfsE_WRRoq=2U@mail.gmail.com>
Date: Thu, 12 Aug 2010 01:48:33 +0530
Message-ID: <AANLkTimqDVGHR+65+35jCAYauvPD8MKwsUdmnJJmH0EU@mail.gmail.com>
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

Oops didn't notice ,,,

Thanks,
Kishore

On Thu, Aug 12, 2010 at 1:42 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Kishore,
>
> On Wed, Aug 11, 2010 at 11:09 PM, kishore kadiyala
> <kishorek.kadiyala@gmail.com> wrote:
>> Since you specified the voltage source is fixed, and if MMC3 has any
>> dedicated regulator as MMC1 & MMC2 you can go with
>> Roger's comments.
>
> You are reading an old batch of the patches.
>
> Scroll down to v4 ;)
>
> Thanks,
> Ohad.
>
>> If the LDO is fixed voltage source from TWL then since regulator
>> framework supports only adjustable LDO's, I think you can
>> have ocr_mask defined as above in board file.
>>
>> Regards,
>> Kishore
>>>
>>> Removed, thanks!
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
