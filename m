Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:41055 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYCBPSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 10:18:10 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: fix eeprom parser length sanity checks
Date: Sun, 2 Mar 2008 16:18:13 +0100
Cc: Michael Wu <flamingice@sourmilk.net>,
	Christian Lamparter <chunkeey@web.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1204324105.3938.49.camel@johannes.berg>
In-Reply-To: <1204324105.3938.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200803021618.14123.florian.fainelli@telecomint.eu> (sfid-20080302_151815_805686_C12F6F21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again Johannes,

Le vendredi 29 f=E9vrier 2008, Johannes Berg a =E9crit=A0:
> When I called p54_parse_eeprom() on a hand-coded structure
> I managed to make a small mistake with wrap->len which caused
> a segfault a few lines down when trying to read entry->len.
> This patch changes the validation code to avoid such problems.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I confirm this patch works, thanks Johannes. Tested with an Inventel UR=
054g=20
dongle.

Tested-by: Florian Fainelli <florian.fainelli@telecomint.eu>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
