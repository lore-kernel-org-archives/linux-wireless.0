Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38975 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZEEFgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 01:36:06 -0400
Received: by gxk10 with SMTP id 10so8795514gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 22:36:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090504224952.GB9342@joutaro.lan>
References: <200905021218.23747.alf@mypals.org>
	 <1241298894.13562.28.camel@johannes.local>
	 <200905021553.55173.alf@mypals.org>
	 <20090504224952.GB9342@joutaro.lan>
Date: Tue, 5 May 2009 01:36:06 -0400
Message-ID: <b6c5339f0905042236o7ab21feai5aef015510428d02@mail.gmail.com>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
From: Bob Copeland <me@bobcopeland.com>
To: Alf <alf@mypals.org>
Cc: Tulio Magno Quites Machado Filho <tuliom@quites.com.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 6:49 PM, Tulio Magno Quites Machado Filho
<tuliom@quites.com.br> wrote:
> On May 02 09 15:53, Alf wrote:
>> Does anyone know if this card is supported? =A0Anybody know why this=
 card
>> works sometimes but most of the time it can't associate with the AP?
>
> I think so (http://wireless.kernel.org/en/users/Drivers/ath5k#support=
edchips).

Yes, 2413 should work -- also can you try latest
wireless-testing tree?  It has a boatload of updates for
ath5k.  If something there works then we can perhaps narrow
it down a bit.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
