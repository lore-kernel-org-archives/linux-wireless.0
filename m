Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37343 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaDWNzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 09:55:53 -0400
Received: by mail-ob0-f174.google.com with SMTP id gq1so1051127obb.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2014 06:55:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140422151840.GH24905@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
	<1397544101-18135-3-git-send-email-wens@csie.org>
	<CACRpkdZ+3dnhoj1TS4KSVUP8iFHsjjwop-FG2Nf07YtH6aSO_Q@mail.gmail.com>
	<20140422151840.GH24905@lukather>
Date: Wed, 23 Apr 2014 15:55:52 +0200
Message-ID: <CACRpkdbdgkYEGWpQiX0WuvS3iivfAyz0r+oK=5D8WB_e=0js2A@mail.gmail.com> (sfid-20140423_155629_382815_34DC3EC2)
Subject: Re: [PATCH 2/7] gpiolib: Support purely name based gpiod lookup in
 device trees
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
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

On Tue, Apr 22, 2014 at 5:18 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> This patch has a dependency on the first patch of this serie, since it
> uses a binding that was documented there.
>
> Maybe you'll want to wait for the ACK from the DT maintainers to merge
> this one.

Yeah I realized this a bit later, sorry for being a bit confused :-/

Yours,
Linus Walleij
