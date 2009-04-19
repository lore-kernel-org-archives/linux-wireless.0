Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46379 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754999AbZDSRd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:33:57 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 19:33:54 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240160241.28138.4.camel@johannes.local>
Message-ID: <20090419173354.158790@gmx.net> (sfid-20090419_193413_781741_0B289F9F)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>	 <20090419125212.158800@gmx.net>	
 (sfid-20090419_145246_566920_BF082D12)
 <1240147050.25826.5.camel@johannes.local>	 <20090419133544.158820@gmx.net>	
 (sfid-20090419_153615_967882_D1A9F951)
 <1240148519.898.3.camel@johannes.local>	 <20090419140523.158830@gmx.net>	
 (sfid-20090419_160555_446977_A429511B)
 <1240150277.898.7.camel@johannes.local>	 <20090419151629.158790@gmx.net>	
 (sfid-20090419_171702_263242_9A8C16F9)
 <1240154704.898.18.camel@johannes.local>	 <20090419155319.158810@gmx.net>	
 (sfid-20090419_175352_161479_A88396A3)
 <1240156631.917.1.camel@johannes.local>	 <20090419161316.158790@gmx.net>	
 (sfid-20090419_181324_681308_BAEAE072)
 <1240158381.917.21.camel@johannes.local>	 <20090419165443.158820@gmx.net>
 (sfid-20090419_185516_519795_36D34B9B) <1240160241.28138.4.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I still haven't understood why those extra commands are bothering you=
 so
> much.

I want a simple generic API. I don't want to need the old wext for it.

This would be stupid for me:
iwconfig wlan0 essid test_essid
vs.
iw dev wlan0 assoc test_essid
iw dev wlan0 join_ibss test_essid
iw dev wlan0 set meshid test_essid

On the last I get MS-DOS feeling.

> Anyhow, you don't _connect_ to an IBSS so that would simply be
> _wrong_.

Then call it join or whatever you want.

"to join: [Ad-Hoc oder Managed Netzwerk] beitreten, trat bei, beigetret=
en" --- leo.org

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
