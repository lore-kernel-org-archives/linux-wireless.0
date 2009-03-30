Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4183 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZC3MCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 08:02:22 -0400
Date: Mon, 30 Mar 2009 08:00:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090330120028.GA29297@hash.localnet> (sfid-20090330_140227_577571_DE62C694)
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com> <20090324184100.GA29268@tesla> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> <1237926664.4320.131.camel@johannes.local> <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com> <20090328163929.GA24075@hash.localnet> <40f31dec0903291613w6b6520a5ucf8daeede7a6ae0@mail.gmail.com> <40f31dec0903291615g73443eccpf2e41efc7460104@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0903291615g73443eccpf2e41efc7460104@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 02:15:34AM +0300, Nick Kossifidis wrote:
> >> Nick, what do you think of this? ??I think it's the best compromise
> >> for now - people can still get all the channels, normal users get a
> >> nice speedup in the default case.
> >>
> 
> By the way it would be nice if you could also clean up CHANNEL_DEBUG
> stuff from ath5k.h etc ;-)

Ah, sure, will do that in a followup (also ATH_CHAN_MAX & friends).

-- 
Bob Copeland %% www.bobcopeland.com

