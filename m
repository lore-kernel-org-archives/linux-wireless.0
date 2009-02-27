Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38408 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754271AbZB0PjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 10:39:24 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 16:39:21 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090227153516.318880@gmx.net>
Message-ID: <20090227153921.254900@gmx.net> (sfid-20090227_163927_307466_29923B6A)
MIME-Version: 1.0
References: <20090226234307.51520@gmx.net> <200902271503.13308.mb@bu3sch.de>
 <20090227153516.318880@gmx.net>
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
To: mb@bu3sch.de
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think after all changes which affect the selected network a rejoin
> should be done.
>=20
> For example you have at channel 4 a AP with the SSID "test" und at ch=
annel
> 11 an other AP with the same SSID, too.
>=20
> If you now first say set_ssid("test") and then set_channel(11), we fi=
rst
> join the network at channel 4 and then we switch the hardware low-lev=
el to
> channel 11. So we hang now in channel 4 with the BSSID of the network=
 in
> channel 4 and nothing works anymore.

So we hang now in channel _11_ with the BSSID of the network in
channel 4 and nothing works anymore.

> I think the order of the commands should not affect the result on the=
 end
> and the driver should never hang in an broken/undefined state if it c=
an be
> recovered.

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
