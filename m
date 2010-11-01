Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51902 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0KAS46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 14:56:58 -0400
Received: by yxk8 with SMTP id 8so3095894yxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 11:56:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikqw5oVTd66DeQGrPgyPAqh66dm6jCvNFSeHpQi@mail.gmail.com>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
	<20101005131744.GB4074@tuxdriver.com>
	<20101005195039.GD11831@tux>
	<AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
	<4CB0890D.3050208@openwrt.org>
	<4CCA0908.6000105@candelatech.com>
	<4CCA0B26.5010008@openwrt.org>
	<AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
	<AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com>
	<AANLkTinVu-DPdS43rMjDc0MMVDXMPHvKtbVfQJE8Ny=C@mail.gmail.com>
	<AANLkTikqw5oVTd66DeQGrPgyPAqh66dm6jCvNFSeHpQi@mail.gmail.com>
Date: Mon, 1 Nov 2010 14:56:55 -0400
Message-ID: <AANLkTikWKkQYa1JtkEymV7Rc+ePpfce=8mDTADEv2nUp@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/1 Björn Smedman <bjorn.smedman@venatech.se>:
> 2010/11/1 Bob Copeland <me@bobcopeland.com>:
>> late-comers know which data is serialized by the barrier.  In the best
>> case, said late-comers are more knowledgeable than me and fix the crap
>> code that I write.
>
> First let me apologize for the tone in my previous mail. It came out
> too hard this Monday (due to a long and unwanted weekend of debugging
> ath9k DMA errors). I did not mean to suggest that any code is crap
> regardless of origin (except maybe if I wrote it).

Err, no worries, I don't think anyone took it that way (I don't do much
ath9k stuff anyway).  I literally meant my own code is often crap so I
try to leave breadcrumbs for people, esp for nitpicky things like
barriers :)

> Thanx Bob for your input. If we agree the memory barriers are needed
> for correctness I will add comments and post as PATCH.

Sure, my opinion may not matter for ath9k, but I think it is a good
idea.

-- 
Bob Copeland %% www.bobcopeland.com
