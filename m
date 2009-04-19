Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753795AbZDSSSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 14:18:25 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 20:18:20 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240164047.28138.9.camel@johannes.local>
Message-ID: <20090419181820.158810@gmx.net> (sfid-20090419_201828_148172_7894E446)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local>	 <20090419143337.158810@gmx.net>
 <20090419163204.158820@gmx.net>	 (sfid-20090419_183237_340935_6640098A)
 <1240160041.28138.0.camel@johannes.local>	 <20090419171546.158830@gmx.net>	
 (sfid-20090419_191552_279073_CA045D96)
 <1240161550.28138.6.camel@johannes.local>	 <20090419174538.140620@gmx.net>
 (sfid-20090419_194610_734041_B2E7FCEC) <1240164047.28138.9.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> No, that's not true, you could well want to create your network on a
> channel that isn't used that much or whatever.

Okay that's is an argument. But then I would implement it more closer t=
o the the handling of the assoc() call.

 * @channel: The channel to use or %NULL if not specified
 * (auto-select based on scan results)
 * @channel_auto: Auto-select channel based on scan results,
 * only use the specified channel for creating a new IBSS.

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
