Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48390 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752679AbZCKNbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 09:31:51 -0400
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 11 Mar 2009 14:31:47 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1236772410.20266.7.camel@johannes.local>
Message-ID: <20090311133147.228080@gmx.net> (sfid-20090311_143230_846193_496CD899)
MIME-Version: 1.0
References: <20090309234946.99940@gmx.net>	
 (sfid-20090310_005017_999744_57F45C40)
 <1236669682.9658.34.camel@johannes.local>	 <20090310224427.223760@gmx.net>
 (sfid-20090310_234458_784141_4631D28F) <1236772410.20266.7.camel@johannes.local>
Subject: Re: [PATCH] mac80211: ieee80211_ibss_commit() cleanup
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> > For unification with the STA implementation=20
>=20
> FWIW, I don't see that as something that is necessarily desirable, I'=
ve
> split them up to allow them to diverge further and in a manageable wa=
y.

I mean not the code itself but the coding style. So that you can better=
 understand the code of the one mode, if you read the code of the other=
 mode before. Sorry, for my bad English.

Regards
Alina

--=20
Nur bis 16.03.! DSL-Komplettanschluss inkl. WLAN-Modem f=FCr nur=20
17,95 =BF/mtl. + 1 Monat gratis!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1=
1308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
