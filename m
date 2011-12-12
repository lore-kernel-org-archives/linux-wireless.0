Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45495 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1LLSx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 13:53:29 -0500
Received: by eaaj10 with SMTP id j10so802495eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 10:53:28 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH v2] mac80211: split addba retries in time
Date: Mon, 12 Dec 2011 19:53:24 +0100
Message-ID: <3179302.KAeCDJhro2@helmutmobil.site> (sfid-20111212_195333_280219_9B07B193)
In-Reply-To: <CALGY4fvo7DMp+_+=wU+072v7sfA6EWfd_weM-G4B3ZxVYEaWhA@mail.gmail.com>
References: <1323162576.4696.4.camel@jlt3.sipsolutions.net> <CAGXE3d8YkkJiuTyZJ=y4j0b5BhZtm1tjO=QxauR15_b=SewTVQ@mail.gmail.com> <CALGY4fvo7DMp+_+=wU+072v7sfA6EWfd_weM-G4B3ZxVYEaWhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 9. Dezember 2011, 23:32:55 schrieb Nikolay Martynov:
> Hi,
> 
> > This is not 100% related to your patch but would it also make sense to
> > disallow BA session setup when it was just torn down a second ago?
> 
>   I do not think this makes much sense. BA session is created when
> connection is being used (i.e. there is something to aggregate). And
> this could happen at any time, even right after BA session was torn
> down after timeout.

Yep, sure. I thought more about a case where the receiving peer wants us
to tear down the BA session for whatever reason (some Windows clients seem
to do that in some cases) ...

Helmut
