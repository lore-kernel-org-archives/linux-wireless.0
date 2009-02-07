Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752285AbZBGPU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 10:20:29 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 07 Feb 2009 16:20:27 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090207150934.694935381@sipsolutions.net>
Message-ID: <20090207152027.327130@gmx.net> (sfid-20090207_162033_933116_B0B2FF21)
MIME-Version: 1.0
References: <20090207150846.951229208@sipsolutions.net>
 <20090207150934.694935381@sipsolutions.net>
Subject: Re: [PATCH 1/4] mac80211: dont add BSS when creating IBSS
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> There's no need to create a BSS struct only to pass it to
> ieee80211_sta_join_ibss, so refactor this function into
> __ieee80211_sta_join_ibss

I think the use of the internal prefix "__" is a little deceptive in th=
is case. But this is only cosmetic.

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
