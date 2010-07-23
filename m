Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36808 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752748Ab0GWJPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 05:15:07 -0400
Date: Fri, 23 Jul 2010 10:15:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Roger Quadros <roger.quadros@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 10/20] omap: zoom: add fixed regulator device for
 wlan
Message-ID: <20100723091503.GA12300@rakim.wolfsonmicro.main>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
 <1279733634-21974-11-git-send-email-ohad@wizery.com>
 <20100721175930.GD10930@sirena.org.uk>
 <4C48287D.1000603@nokia.com>
 <AANLkTin2dyLNo1RMQgLG-4DtN-CsXqNNLAfITXDbMIvl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTin2dyLNo1RMQgLG-4DtN-CsXqNNLAfITXDbMIvl@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 23, 2010 at 02:13:38AM +0300, Ohad Ben-Cohen wrote:
> On Thu, Jul 22, 2010 at 2:16 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
> > .dev_name       = "mmci-omap-hs.2"

> I already set the .dev member of the consumer in a similar manner to
> how all other regulators are configured in this board - please check
> out patch 13:

> https://patchwork.kernel.org/patch/113418/

> Does this look reasonable to you ?

You should really be using dev_name in preference to dev these days
unless there's a *very* good reason.
