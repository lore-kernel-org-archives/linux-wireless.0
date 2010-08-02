Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60923 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0HBQTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 12:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimaSeLqowRHSCivGXTiSE7NatNTR=jLWQYsSo-6@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<20100726193028.GG3903@tuxdriver.com>
	<1280736987.17809.18.camel@chilepepper>
	<20100802114256.GE12293@atomide.com>
	<AANLkTikvtMbqUdwHtCtdL2xXbQh64pxjApo6ZH6hAXnP@mail.gmail.com>
	<AANLkTimaSeLqowRHSCivGXTiSE7NatNTR=jLWQYsSo-6@mail.gmail.com>
Date: Mon, 2 Aug 2010 18:19:04 +0200
Message-ID: <AANLkTikPSp0_S8kSFmeZJ0qLR3DHKBN=iW_As5891a6v@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] native support for wl1271 on ZOOM
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
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

Hi Ohad,

On Mon, Aug 2, 2010 at 5:59 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> Check out patch no. 9:

sorry for the confusion. However, I guess if the platform doesn't
supply this value, we'll just consider it 0? Without any warning,
right?

The problem is, we can't really distinguish between this field not set
and value zero, and that means something is wrong with the design. The
easiest way is probably changing the clock ids to start with 1.

Thanks,
   Vitaly
