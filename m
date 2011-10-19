Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48709 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1JSLdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 07:33:54 -0400
Received: by ywf7 with SMTP id 7so1563328ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 04:33:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319018802.31281.YahooMailNeo@web161205.mail.bf1.yahoo.com>
References: <loom.20110621T215346-191@post.gmane.org>
	<BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
	<1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
	<1308750416.29571.10.camel@jlt3.sipsolutions.net>
	<1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
	<1308754204.29571.15.camel@jlt3.sipsolutions.net>
	<1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
	<BANLkTi=Ob1H7XdG5-21SnjkuyVF9xw+xBA@mail.gmail.com>
	<1319018802.31281.YahooMailNeo@web161205.mail.bf1.yahoo.com>
Date: Wed, 19 Oct 2011 19:33:53 +0800
Message-ID: <CAJ-VmokZibCys+9ZLg6yEbauJfbgErbezMcTZ2SjPmR9SMgQ7w@mail.gmail.com> (sfid-20111019_133357_284146_C3D17D0E)
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211 and ath5k/mac80211
From: Adrian Chadd <adrian@freebsd.org>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. does madwifi have that net80211 "aggressive mode" by default, where
it overrides the best-effort WME queue parameters to allow for
bursting?

I see exactly that difference in FreeBSD (33mbit vs 22mbit) when I
disable that aggressive mode code.

Thanks,


Adrian
