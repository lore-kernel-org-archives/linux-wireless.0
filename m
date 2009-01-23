Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754312AbZAWWnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:43:16 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 23 Jan 2009 23:43:15 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <43e72e890901230547w1ca9b24cp632df359e619c980@mail.gmail.com>
Message-ID: <20090123224315.50450@gmx.net> (sfid-20090123_234321_861479_94D60D14)
MIME-Version: 1.0
References: <20090123043337.270720@gmx.net>
 <43e72e890901230547w1ca9b24cp632df359e619c980@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Read the TSF via debugfs
To: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis!

> Alina, a few notes on this series. I see you have used the mac80211
> ops get_tsf via debugfs, and then added one for ath5k and ath9k. It
> would seem a driver-specific get tsf from debugfs is not needed then.
> The set_tsf is the only one that seems to be driver specific and coul=
d
> probably go into their own debugfs.  Anyway how about instead of all
> this just adding a new mac80211 ops for set_tsf for mac80211 as well
> and then just add nl80211 commands to be able to get/set/reset them?
> This way if the driver implements them it'll be through a generic
> interface and also we can start using it via iw.

If the others agree I would very happy to implement it. :)

I only don't want to change to much in the infrastructure, but this wou=
ld be the nicest way to implement it.

Regards
Alina

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
