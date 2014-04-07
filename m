Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.msg.oleane.net ([62.161.4.28]:42112 "EHLO
	smtp28.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaDGNs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 09:48:57 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Janusz Dziedzic'" <janusz.dziedzic@gmail.com>,
	"'voncken'" <cedric.voncke@acksys.fr>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local>	<CAFED-j=nyEnfg7n=OF0oA_Geh11DR_XYNPTLeb603jKNNUxv0g@mail.gmail.com>	<00dc01cf5259$94fd02d0$bef70870$@acksys.fr> <CAFED-jkwWPu56R7aTHhkQqbk5SyU2pKD38Z+jJ5e7HEB7xrc+A@mail.gmail.com>
In-Reply-To: <CAFED-jkwWPu56R7aTHhkQqbk5SyU2pKD38Z+jJ5e7HEB7xrc+A@mail.gmail.com>
Subject: RE: [MAC80211] Radar detection management issue
Date: Mon, 7 Apr 2014 15:48:52 +0200
Message-ID: <000601cf5268$1cb58bd0$5620a370$@acksys.fr> (sfid-20140407_154946_080653_5755AAF8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> >         I'm looking in net/mac80211.h the IEEE80211 flag relevant to
> > DFS (to add the test in ath9k init), but I don't found it.
> >
> >         It seem the mac80211 do not know the hardware capability to
> > detect radar.
> >
> Driver set this in iface_combinations (check):
> 
>   .radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
>                                        BIT(NL80211_CHAN_WIDTH_20),
> 

I'm sorry, but I don't understand:
	how the low level driver (ath9k) advise the MAC80211 driver of radar
detection capabilities.
	How the MAC80211 driver disable the channel if the DFS is not
supported by the low level driver.

Cedric.

> BR
> Janusz

