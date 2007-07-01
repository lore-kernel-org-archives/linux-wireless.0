Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:52122 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbXGAWJV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2007 18:09:21 -0400
Date: Sun, 1 Jul 2007 23:35:15 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Joerg Mayer <jmayer@loplof.de>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: basic regulatory domain support
Message-ID: <20070701213515.GA6829@deine-taler.de>
References: <20070701163907.39B6B7B409F@zog.reactivated.net> <20070701203238.GE8218@thot.informatik.uni-kl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20070701203238.GE8218@thot.informatik.uni-kl.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-01 22:32 Joerg Mayer wrote:

> On Sun, Jul 01, 2007 at 05:39:06PM +0100, Daniel Drake wrote:
> > This patch causes zd1211rw-mac80211 to interpret the regdomain in t=
he
> > EEPROM and restrict the channels accordingly, like the softmac driv=
er does.
>=20
> The patch only addresses the allowed channels but not the allowed
> maximum power levels. Is this intentional?
> I've only looked at the patch, so maybe this is handled elsewhere.
>=20
>=20
>  ciao
>        Joerg

J=F6rg,

this is not an easy task, because ZD1211 devices have
numerous different constructions affecting the antenna forms and
sizes and a greater number of different RF chips. BTW we have no
documentation about the registers controlling the output power.
We are currently using the register parameters the vendor driver
is using. If somebody could provide ongoing measurements, that
would give us the data points to work on the issue.

Kind regards,

Ulrich

--=20
Uli Kunitz
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
