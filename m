Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751773AbZBIW3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:29:17 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 09 Feb 2009 23:29:15 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1234217077.4175.257.camel@johannes.local>
Message-ID: <20090209222915.90830@gmx.net> (sfid-20090209_232919_663115_E8D7EFB9)
MIME-Version: 1.0
References: <1234217077.4175.257.camel@johannes.local>
Subject: Re: [PATCH] mac80211: split managed/ibss code a little more
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> It appears that you can completely mess up mac80211 in IBSS
> mode by sending it a disassoc or deauth: it'll stop queues
> and do a lot more but not ever do anything again. Fix this
> by not handling all those frames in IBSS mode,=20

This is a huge change. Hopefully it doesn't break anything.

Applying this patch fails for me. Can you please send me your mlme.c?

Regards
Alina

--=20
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
