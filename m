Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752202AbZBHRpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 12:45:21 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 08 Feb 2009 18:45:19 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1234089364.4175.113.camel@johannes.local>
Message-ID: <20090208174519.109630@gmx.net> (sfid-20090208_184526_263798_15A5ADB7)
MIME-Version: 1.0
References: <20090207233507.67590@gmx.net>	
 (sfid-20090208_003539_503598_424F18AB)
 <1234089364.4175.113.camel@johannes.local>
Subject: Re: generic ieee80211_sta_commit()?
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> What if you set the SSID again? I'd think that would help?

Yes it only works again if you do so.

> That could make sense, not exactly sure at this point. I'm also still
> wondering about the other issue with turning _off_ IBSS, with essid o=
ff
> or so, see my other mail.

What mail do you mean?

> Sounds reasonable, if it fixes a bug.

I think it's a clean-up, too.

> I'd have to see the patch, I
> guess. I'd like to also do assoc/IBSS stuff in cfg80211 at some point
> soonish.

How do you mean it?

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
