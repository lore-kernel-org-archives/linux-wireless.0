Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:38472 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYJ2PHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 11:07:18 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
References: <87prlr9mna.fsf@denkblock.local>
	<40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com>
	<87abcrtfa8.fsf@denkblock.local>
	<40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	<87wsfvt76q.fsf@denkblock.local>
	<40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	<87r663t1ds.fsf@denkblock.local>
	<40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com>
	<873aifsfc9.fsf@denkblock.local>
	<40f31dec0810290749u2c065d17g5788eb22cf508142@mail.gmail.com>
Date: Wed, 29 Oct 2008 16:07:06 +0100
In-Reply-To: <40f31dec0810290749u2c065d17g5788eb22cf508142@mail.gmail.com>
	(Nick Kossifidis's message of "Wed, 29 Oct 2008 16:49:29 +0200")
Message-ID: <87wsfrqw2t.fsf@denkblock.local> (sfid-20081029_160723_723922_A8DF8854)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> wrote:
> 2008/10/29 Elias Oltmanns <eo@nebensachen.de>:
>>
>
>> Right, so here is another attempt. Unfortunately, in 2.6.27 no constants
>> have been defined for the phy revisions, nor the 0xa228 register and the
>> bit masks involved in resetting this register. Perhaps we should consult
>> the stable team on this matter because the minimal approach, as
>> presented below, certainly lacks even the smallest degree of readability
>> even though we actually know reasonably well what we are doing here. The
>> changelog, by the way, will be adapted to quote your changeset fixing
>> this in mainline once it has been committed. What do you think?
>>
>
> Patch looks OK, thanks a lot ;-)
>
> John can we get this get in stable until i update reset.c on wireless-testing ?
> Would it be possible later to update mainline from wireless-testing ?

Reading Documentation/stable_kernel_rules.txt, I very much doubt that
this patch will go in unless we can at least point out something
equivalent in mainline. So, we'll have to wait until your changes to
reset.c have reached mainline, I'm afraid.

Regards,

Elias
