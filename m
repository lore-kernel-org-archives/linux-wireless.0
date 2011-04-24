Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab1DXK2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 06:28:16 -0400
Subject: Re: [PATCH 4/4] iwlwifi: split the drivers for agn and legacy
 devices 3945/4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
In-Reply-To: <1303638394.14128.1.camel@maxim-laptop> (sfid-20110424_114700_368075_72827394)
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
	 <1303558517.8537.7.camel@maxim-laptop>
	 <1303562444.11751.6.camel@maxim-laptop>
	 <1303632781.3795.5.camel@jlt3.sipsolutions.net>
	 <1303638394.14128.1.camel@maxim-laptop>
	 (sfid-20110424_114700_368075_72827394)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 12:28:11 +0200
Message-ID: <1303640891.30421.1.camel@jlt3.sipsolutions.net> (sfid-20110424_122819_201569_C99E6698)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 12:46 +0300, Maxim Levitsky wrote:

> > > I wonder how such bug could escape unnoticed.
> > > Nobody uses linux these days I guess.... :-(
> > 
> > Wow, so you're one of the people who think the LED blinking is the most
> > important thing... good job...
> Good job to you for insulting peoples.

You're right I guess, that was uncalled for, sorry. Do you really
believe nobody uses Linux? :-)


> > Anyhow this was intentional, it's supposed to blink in that mode
> > according to the product documentation. If you don't like it, you can
> > now override it in sysfs.

> You mean, led is supposed to constantly blink while there is no traffic?
> You are kidding aren't you?
> At least led doesn't behave like that on any other wireless card, nor it
> does in windows

No, I'm not kidding, I know that I looked this up in the product
documentation when I wrote the patch that Wey-Yi referred to. I didn't
look at the 3945/4965, but the second generation AGN (5000+, 6000+ etc)
hw is supposed to behave that way, and later (1000+ or so?) are supposed
to just have on/off with the radio (by default).

Anyhow, I don't much care what happens to iwlegacy.

johannes

