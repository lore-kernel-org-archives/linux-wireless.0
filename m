Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44094 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZELNgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 09:36:07 -0400
Received: by bwz22 with SMTP id 22so3275762bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 06:36:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905052142.38780.alf@mypals.org>
References: <200905021218.23747.alf@mypals.org>
	 <20090504224952.GB9342@joutaro.lan>
	 <b6c5339f0905042236o7ab21feai5aef015510428d02@mail.gmail.com>
	 <200905052142.38780.alf@mypals.org>
Date: Tue, 12 May 2009 16:36:04 +0300
Message-ID: <40f31dec0905120636i592e29e3n29b88c763fd9739e@mail.gmail.com>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
From: Nick Kossifidis <mickflemm@gmail.com>
To: Alf <alf@mypals.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	Tulio Magno Quites Machado Filho <tuliom@quites.com.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/6 Alf <alf@mypals.org>:
>
> I tried it a few days ago and it still didn't work. =C2=A0Even the la=
test
> snapshot from madwifi didn't work. =C2=A0They only thing that has wor=
ked is
> ndiswrapper.

Hmm, do you use a driver from your vendor (the inf files etc from CD)
or a generic one from the net ?

It's possible that your vendor uses hardcoded settings on the driver
instead of EEPROM settings so tx power wont work as expected and
that's why you can't connect on the AP. Both ath5k and MadWiFi try to
use EEPROM settings, they don't use any hardcoded settings (not even
default values in case of a corrupted EEPROM -we should fix that in
the future).

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
