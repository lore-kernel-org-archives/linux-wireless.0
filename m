Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0FLCDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 22:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <1276288163.3918.1.camel@jlt3.sipsolutions.net>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com>
	<AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
	<AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com>
	<1276286993.3918.0.camel@jlt3.sipsolutions.net> <AANLkTim90VBfWjp2YPYeYN6ImjIyZzcJ_XnpT5cdgCt4@mail.gmail.com>
	<1276288163.3918.1.camel@jlt3.sipsolutions.net>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Sat, 12 Jun 2010 05:02:53 +0300
Message-ID: <AANLkTinA0cEXRVtD8iP1UhOsdYsSRONagfX7yQbMl_DG@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds
	support. If leds support enabled do not force mac802.11 leds layer selection.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	GeunSik Lim <geunsik.lim@samsung.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Keng-Yu Lin <keng-yu.lin@canonical.com>,
	netdev@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Shahar Or <shahar@shahar-or.co.il>,
	linux-kernel@vger.kernel.org, Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this case no way to control LEDs. If you turn LEDs support you
can't tune them out, no?

I believe that user should be able to chose whether LEDs support is
needed or not. This is how done in intel wireless drivers. The driver
should be tolerant.

-- Dima

On Fri, Jun 11, 2010 at 11:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-06-11 at 23:26 +0300, Dmytro Milinevskyy wrote:
>> Generic LED class is not disabled so it's possible to control leds in sysfs.
>
> But if you turn off ATH5K_LEDS??
>
> johannes
>
>
