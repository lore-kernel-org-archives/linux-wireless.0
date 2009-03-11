Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751395AbZCKNnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 09:43:33 -0400
Cc: samuel@sortiz.org, j@w1.fi
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 11 Mar 2009 14:43:29 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1236774973.20266.13.camel@johannes.local>
Message-ID: <20090311134329.269810@gmx.net> (sfid-20090311_144412_071211_DBD14B06)
MIME-Version: 1.0
References: <1236774973.20266.13.camel@johannes.local>
Subject: Re: configuring while interface is down
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> For cfg80211's assoc/ibss calls, I think we should reject them outrig=
ht
> when the interface is down, any objections?

How should assoc in cfg80211 work?

=46or WEXT I like collecting all changes while the interface is down an=
d the if it's up again apply them in one step. That is the reason why I=
 want call "*_commit()" on interface up.

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
