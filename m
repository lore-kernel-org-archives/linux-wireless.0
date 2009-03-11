Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45315 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750770AbZCKP6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 11:58:19 -0400
Cc: j@w1.fi, samuel@sortiz.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 11 Mar 2009 16:58:12 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1236779314.20266.22.camel@johannes.local>
Message-ID: <20090311155812.269850@gmx.net> (sfid-20090311_165927_403368_FB4B61FF)
MIME-Version: 1.0
References: <1236774973.20266.13.camel@johannes.local>	
 <20090311134329.269810@gmx.net> (sfid-20090311_144435_584837_2198C4E4)
 <1236779314.20266.22.camel@johannes.local>
Subject: Re: configuring while interface is down
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> which is what we'll continue doing in cfg80211, but I think we should=
n't
> bother the driver/mac80211 with it until the netdev is up, and thus
> reject things from nl80211.

Do you think WEXT should only be a wrapper around cfg80211? If yes, I w=
ould agree.

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
