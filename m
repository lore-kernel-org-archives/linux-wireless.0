Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab1FVUW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:22:28 -0400
Received: by iyb12 with SMTP id 12so973332iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 13:22:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110622200419.GD13533@tuxdriver.com>
References: <1308422749-16939-1-git-send-email-arik@wizery.com>
 <87ips11tc3.fsf@purkki.adurom.net> <20110622200419.GD13533@tuxdriver.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 22 Jun 2011 23:22:12 +0300
Message-ID: <BANLkTin2thiPEE4gCTURjRjyN6y2yv7i-Q@mail.gmail.com> (sfid-20110622_222230_939652_7F74545A)
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic failure
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > > -   mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
> > > +   mac80211_ev_michael_mic_failure(rx->sdata,
> > > +                                   rx->key ? rx->key->conf.keyidx : -1,
> > >                                     (void *) skb->data, NULL, GFP_ATOMIC);
> >
> > In special cases like this a comment in the code would be nice.
>
> Repost with a comment, as Kalle requested?
>

Sure thing.

Arik
