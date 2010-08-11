Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34285 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753318Ab0HKVDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 17:03:14 -0400
Date: Wed, 11 Aug 2010 22:03:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: kishore kadiyala <kishorek.kadiyala@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v3 9/9] omap: zoom: add mmc3/wl1271 device support
Message-ID: <20100811210311.GA10207@rakim.wolfsonmicro.main>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
 <1281478348-24833-10-git-send-email-ohad@wizery.com>
 <4C626140.3080107@nokia.com>
 <AANLkTik8yftwy9Toq473134vcdoFN1Z29oTc9MGEUzue@mail.gmail.com>
 <AANLkTi=n=uH5ePRf8KzXWTtSdyRabpOCOgLBSD1GfwkJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=n=uH5ePRf8KzXWTtSdyRabpOCOgLBSD1GfwkJ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 12, 2010 at 01:39:38AM +0530, kishore kadiyala wrote:

> If the LDO is fixed voltage source from TWL then since regulator
> framework supports only adjustable LDO's, I think you can

The regulator framework supports fixed voltage regulators just fine.
