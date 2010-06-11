Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53247 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0FKRHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 13:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com>
References: <4c0f4326.0a41df0a.7bde.ffffeef2@mx.google.com>
	<AANLkTilrYYHjcMEhhrP7zjcLoo-TNczozxJSNRkDvSZy@mail.gmail.com>
	<AANLkTimXqdkQxv_Y1JaleTTWNsDIQHQaPn8HR7efOupb@mail.gmail.com>
Date: Fri, 11 Jun 2010 13:07:42 -0400
Message-ID: <AANLkTimUW58T19GOkRk3oCC9huLDQLgLj4W3RjiQ9n53@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds
	support. If leds support enabled do not force mac802.11 leds layer selection.
From: Bob Copeland <me@bobcopeland.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	GeunSik Lim <geunsik.lim@samsung.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jiri Slaby <jirislaby@gmail.com>, netdev@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Keng-Yu Lin <keng-yu.lin@canonical.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Shahar Or <shahar@shahar-or.co.il>,
	linux-kernel@vger.kernel.org, Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 9, 2010 at 10:43 AM, Dmytro Milinevskyy
<milinevskyy@gmail.com> wrote:
> Hi, Bob.
>
> For instance I don't use 802.11 leds layer and trigger leds from
> userspace according to my purposes.

FWIW you can disable mac80211 triggers from userspace as well.
But, I guess hooking up null triggers will work too.

-- 
Bob Copeland %% www.bobcopeland.com
