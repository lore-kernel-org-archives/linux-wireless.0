Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50540 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbZEFLyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 07:54:14 -0400
Received: by bwz22 with SMTP id 22so46206bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2009 04:54:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905052142.38780.alf@mypals.org>
References: <200905021218.23747.alf@mypals.org>
	 <20090504224952.GB9342@joutaro.lan>
	 <b6c5339f0905042236o7ab21feai5aef015510428d02@mail.gmail.com>
	 <200905052142.38780.alf@mypals.org>
Date: Wed, 6 May 2009 14:54:13 +0300
Message-ID: <40f31dec0905060454s513c5eeas44389e6527eed1fd@mail.gmail.com>
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
> On Monday 04 May 2009 11:36:06 pm Bob Copeland wrote:
>> Yes, 2413 should work -- also can you try latest
>> wireless-testing tree? =C2=A0It has a boatload of updates for
>> ath5k. =C2=A0If something there works then we can perhaps narrow
>> it down a bit.
>
> I tried it a few days ago and it still didn't work. =C2=A0Even the la=
test
> snapshot from madwifi didn't work. =C2=A0They only thing that has wor=
ked is
> ndiswrapper.
>

Can you please post the full dmesg output when ath5k loads ?



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
