Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59635 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0CYBQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 21:16:21 -0400
Received: by pva18 with SMTP id 18so516697pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 18:16:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100324120645.5b43757c.nledovskih@mail.ru>
References: <20100324120645.5b43757c.nledovskih@mail.ru>
Date: Wed, 24 Mar 2010 18:16:19 -0700
Message-ID: <445f43ac1003241816p2d00b79br224a155b605ce7ac@mail.gmail.com>
Subject: Re: Mesh mode broken since 2.6.34-rc1
From: Javier Cardona <javier@cozybit.com>
To: =?KOI8-R?B?7MXEz9fTy8nIIO7Jy8/Mwcog98HMxdLYxdfJ3g==?=
	<nledovskih@mail.ru>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org,
	"Porsch, Marco" <marco.porsch@siemens.com>,
	"steve.derosier" <steve.derosier@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick,

2010/3/24 Ледовских Николай Валерьевич <nledovskih@mail.ru>:
> Mesh mode does not work any more. I have some x86 MPs with 2.6.33.1, which work fine.
> But there are establishment problems with 2.6.34-rc1.
> The peering status changes between LISTEN, OPN_SNT and HOLDING, but does not reach ESTAB.

Yes, confirmed on our testbed that wireless-testing commit
60b341b778cc2929df16c0a504c91621b3c6a4ad is good.  We'll investigate.

Thanks,

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
