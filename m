Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:54647 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYJ2P2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 11:28:45 -0400
Received: by rv-out-0506.google.com with SMTP id k40so46481rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 08:28:44 -0700 (PDT)
Message-ID: <b6c5339f0810290828g2c600d5cm9f78df9d427f5c1f@mail.gmail.com> (sfid-20081029_162919_828389_4D01BC8C)
Date: Wed, 29 Oct 2008 11:28:44 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87wsfrqw2t.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <87prlr9mna.fsf@denkblock.local> <87abcrtfa8.fsf@denkblock.local>
	 <40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	 <87wsfvt76q.fsf@denkblock.local>
	 <40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	 <87r663t1ds.fsf@denkblock.local>
	 <40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com>
	 <873aifsfc9.fsf@denkblock.local>
	 <40f31dec0810290749u2c065d17g5788eb22cf508142@mail.gmail.com>
	 <87wsfrqw2t.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 11:07 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
>>
>> Patch looks OK, thanks a lot ;-)
>>
>> John can we get this get in stable until i update reset.c on wireless-testing ?
>> Would it be possible later to update mainline from wireless-testing ?
>
> Reading Documentation/stable_kernel_rules.txt, I very much doubt that
> this patch will go in unless we can at least point out something
> equivalent in mainline. So, we'll have to wait until your changes to
> reset.c have reached mainline, I'm afraid.

Or, we could just send your patch to both stable and for 2.6.28.  Then Nick
can fix up the difference or revert it in his rework.  The rework is 2.6.29
material, right?

-- 
Bob Copeland %% www.bobcopeland.com
