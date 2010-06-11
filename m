Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0FKU3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 16:29:49 -0400
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds
 support. If leds support enabled do not force mac802.11 leds layer
 selection.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
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
In-Reply-To: <AANLkTim90VBfWjp2YPYeYN6ImjIyZzcJ_XnpT5cdgCt4@mail.gmail.com>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com>
	 <AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
	 <AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com>
	 <1276286993.3918.0.camel@jlt3.sipsolutions.net>
	 <AANLkTim90VBfWjp2YPYeYN6ImjIyZzcJ_XnpT5cdgCt4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 22:29:23 +0200
Message-ID: <1276288163.3918.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-11 at 23:26 +0300, Dmytro Milinevskyy wrote:
> Generic LED class is not disabled so it's possible to control leds in sysfs.

But if you turn off ATH5K_LEDS??

johannes

