Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50006 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0H3XwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 19:52:20 -0400
Received: by eyg5 with SMTP id 5so3517016eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 16:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikQk5=S=n8rP3hRgu8F=oyGqY_c8rFar7C=kRef@mail.gmail.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
	<AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
	<4C618713.9030303@candelatech.com>
	<AANLkTikanjZf0LEqZjw5toeJz02Tcs6EcAiNdagJh=sQ@mail.gmail.com>
	<AANLkTik9vPPxpxksGhRLkU+5y8YouJ+mbMHMBgt3B+3J@mail.gmail.com>
	<AANLkTikQk5=S=n8rP3hRgu8F=oyGqY_c8rFar7C=kRef@mail.gmail.com>
Date: Tue, 31 Aug 2010 09:52:18 +1000
Message-ID: <AANLkTik-W_=AixLMwqkrJi9JgwjvrDNGnyHOrbyCgP5+@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hey ben,

i've set everything up and have all the routing working etc etc. it
seems as tho' there is one last issue i'm hoping you can point me in
the right direction with.

When the device i'm working on boots i've got hostapd starting up with
two VAP's (vap0 and vap1).  when i connect to on AP everything goes
well and i can send and receive traffic, however when i disconnect and
reconnect to the other AP it seems as tho' the client connection
hangs.

Inspecting syslog shows all the dhcp information  for the 1st
connection, however there is nothing in syslog for the 2nd connection.

have you seen this, or have an idea why it may happen by chance?

regs
R

[cross posted to the hostapd mailing list]
