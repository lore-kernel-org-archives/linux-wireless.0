Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756731AbZDSOF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:05:26 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 16:05:23 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240148519.898.3.camel@johannes.local>
Message-ID: <20090419140523.158830@gmx.net> (sfid-20090419_160530_514781_26A1B0A0)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>	 <20090419125212.158800@gmx.net>	
 (sfid-20090419_145246_566920_BF082D12)
 <1240147050.25826.5.camel@johannes.local>	 <20090419133544.158820@gmx.net>
 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Johannes!

> Huh? No, it does not mostly do the same. Quite not so. Managed and IB=
SS
> modes are _really_ different. Almost the only thing they have in comm=
on
> is that they use an SSID and a BSSID.

A character device is not the same as a block device too but it uses th=
e same API like normal files. Thats the deference to DOS. And assoc() i=
s the equivalent for join_ibss(), like read() or write() it can impleme=
nted with the same interface. In WEXT it's implemented with the same in=
terface.

> And an airy concept of "UNIX philosophy" really has nothing whatsoeve=
r
> to do with it.

Unfortunately I don't have the book "Modern Operating Systems" here so =
I can't quote it.

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
