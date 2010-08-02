Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64879 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0HBPMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 11:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <20100802114256.GE12293@atomide.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<20100726193028.GG3903@tuxdriver.com>
	<1280736987.17809.18.camel@chilepepper>
	<20100802114256.GE12293@atomide.com>
Date: Mon, 2 Aug 2010 17:12:08 +0200
Message-ID: <AANLkTikvtMbqUdwHtCtdL2xXbQh64pxjApo6ZH6hAXnP@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] native support for wl1271 on ZOOM
From: Vitaly Wool <vitalywool@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 2, 2010 at 1:42 PM, Tony Lindgren <tony@atomide.com> wrote:

> Nicolas Pitre made a comment saying he wants to look at these patches
> more, are there other pending comments?

Yep, I'm feeling quite uncomfortable with the way platform data is
being passed over to sdio device now.

Also, specifically to 12xx, I'd like to see REF_CLOCK moved on and
have this set by platform too (I haven't found anything like that in
the patches but maybe I've overlooked that).

Thanks,
   Vitaly
