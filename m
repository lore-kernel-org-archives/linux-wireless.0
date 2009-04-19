Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44188 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756255AbZDSMwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 08:52:17 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 14:52:12 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240097845.25826.1.camel@johannes.local>
Message-ID: <20090419125212.158800@gmx.net> (sfid-20090419_145221_478827_197EF455)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> This adds IBSS API along with (preliminary) wext handlers.
> The wext handlers can only do IBSS so you need to call them
> from your own wext handlers if the mode is IBSS.

Why make not assoc() and disassoc() to a generic mode independent call?=
 Only the handling is deferent on each mode.

Regards
Alina

--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
