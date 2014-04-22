Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50547 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbaDVPAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:00:18 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp4so5834155obc.35
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 08:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397544101-18135-3-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
	<1397544101-18135-3-git-send-email-wens@csie.org>
Date: Tue, 22 Apr 2014 17:00:17 +0200
Message-ID: <CACRpkdZ+3dnhoj1TS4KSVUP8iFHsjjwop-FG2Nf07YtH6aSO_Q@mail.gmail.com> (sfid-20140422_170148_331165_D75FF01D)
Subject: Re: [PATCH 2/7] gpiolib: Support purely name based gpiod lookup in
 device trees
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 15, 2014 at 8:41 AM, Chen-Yu Tsai <wens@csie.org> wrote:

> This patch enables gpio-names based gpiod lookup in device tree usage,
> which ignores the index passed to gpiod_get_index. If this fails, fall
> back to the original function-index ("con_id"-gpios) based lookup scheme,
> for backward compatibility and any drivers needing more than one GPIO
> for any function.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

This looks a bit scary and I cannot claim to realize the entire semantic
effect of this patch, but if it's the way to go then OK.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Shall I just apply this to the GPIO tree or are you carrying it along with
the other stuff?

Yours,
Linus Walleij
