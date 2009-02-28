Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52151 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753435AbZB1TTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2009 14:19:36 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 28 Feb 2009 20:19:33 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <18856.39652.66588.791696@gargle.gargle.HOWL>
Message-ID: <20090228191933.188860@gmx.net> (sfid-20090228_201943_800055_D68F11F5)
MIME-Version: 1.0
References: <20090227220215.254900@gmx.net>
 <18856.39652.66588.791696@gargle.gargle.HOWL>
Subject: Re: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
To: Sujith <m.sujith@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Sujith!

> You don't need a new variable in ath_hal. The RX filter is already ca=
ched
> in
> ath_softc during a configure_filter() call.

I'm asking currently myself, if this code needed at all? Or can it comp=
letely removed?

Sending and receiving probe requests and responses works without it, to=
o. What is the need for this code?

Regards
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
