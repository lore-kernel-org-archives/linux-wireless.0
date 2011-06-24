Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.253]:29075 "HELO
	nm16-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752948Ab1FXMe4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 08:34:56 -0400
References: <loom.20110624T123237-71@post.gmane.org> <201106241307.44609.chunkeey@googlemail.com>
Message-ID: <1308918895.17410.YahooMailRC@web161205.mail.bf1.yahoo.com> (sfid-20110624_143459_921009_FF987A39)
Date: Fri, 24 Jun 2011 05:34:55 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: Configuring the multicast data rate with iw/nl80211
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201106241307.44609.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>Not a good idea... I tried it too, but as soon as a STA goes into PSM [or does 
a
>background scan], it'll affect the stream badly [So, you'll probably need a
>dedicated AP just for your video clients]. The reason is that the AP
>[in my case it was mac80211] will now buffer the transmissions, so you only get
>about 128 frames every 300ms until the STA comes back or disappears.

An interesting and good point. However, I'm in full control of the clients
so I can actually disable PS-Mode. So, while your note of caution is 
appreciated,
it doesn't get me off the hook. As I wrote earlier I'm evaluating a transition
from Madwifi to ath5k. Madwifi with net80211 had an iwpriv call to configure the 

multicast data rate. I'm looking for an equivalent solution with ath5k/mac80211.

>As an alternative, It's worth a try to look into multicast-to-unicast proxies
>such as http://sourceforge.net/projects/udpxy/ .

But then you duplicate the multicast traffic for every STA, no?

Regards
  Joerg

