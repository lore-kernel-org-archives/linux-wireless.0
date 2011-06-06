Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab1FFKde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:33:34 -0400
Subject: Re: [PATCH v3] 802.11n frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikxkvpuDLEsf8Q5b3RZ4PuXYOLGbQ@mail.gmail.com> (sfid-20110606_122947_463950_90061CB8)
References: <BANLkTim_YzVXG5g+92AkvJhhQ4OkeW4wMw@mail.gmail.com>
	 <1307352901.3894.2.camel@jlt3.sipsolutions.net>
	 <BANLkTikxkvpuDLEsf8Q5b3RZ4PuXYOLGbQ@mail.gmail.com>
	 (sfid-20110606_122947_463950_90061CB8)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 12:33:32 +0200
Message-ID: <1307356412.3894.5.camel@jlt3.sipsolutions.net> (sfid-20110606_123337_670091_A0390FCF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 12:28 +0200, Matteo Croce wrote:

> > Also, have you actually _tested_ this patch? I see nothing that would
> > cause rate control to be skipped, so rate control should always override
> > the data you set up here.

> Actually I use this patch on many devices.
> The rate control is not an issue as this patch is intended for
> injecting in monitor mode

Even monitor mode frames still go through rate control handling.

johannes

