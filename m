Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47877 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbeGRTGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 15:06:39 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        Ben Greear <greearb@candelatech.com>,
        SEDE <s.deronne@televic.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Setting tx retry count in ath10k
In-Reply-To: <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com> <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de> <8b9713fe-7573-f009-d002-13df73315898@televic.com> <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com> <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com> <877els5xax.fsf@toke.dk> <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Date: Wed, 18 Jul 2018 20:27:17 +0200
Message-ID: <871sc05ri2.fsf@toke.dk> (sfid-20180718_202734_578427_C3F0A943)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean-Pierre TOSONI <jp.tosoni@acksys.fr> writes:

> @Toke: As you can see in the patch, the value 30 was the fixed value
> defined in ath9k, I kept it for compatibility only (and that's why I
> wanted to make it configurable :-)

Yup, I'm aware that this is the default from ath9k; doesn't make it any
less wrong ;)

> On another hand, Minstrel in mac80211 seems to vary retries according
> to what you say, i.e. Minstrel tries to stay below a certain amount of
> time, but this only applies to short/long retries.

Right, haven't had time to poke into what exactly Minstrel does; have
just observed that it sometimes runs really long. But for most cases
it's not too bad...

-Toke
