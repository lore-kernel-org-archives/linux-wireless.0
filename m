Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33056 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128Ab0KAPoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 11:44:21 -0400
Received: by iwn10 with SMTP id 10so7167013iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 08:44:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
	<20101005131744.GB4074@tuxdriver.com>
	<20101005195039.GD11831@tux>
	<AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
	<4CB0890D.3050208@openwrt.org>
	<4CCA0908.6000105@candelatech.com>
	<4CCA0B26.5010008@openwrt.org>
	<AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
Date: Mon, 1 Nov 2010 16:44:21 +0100
Message-ID: <AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 29, 2010 at 2:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
[snip]
> I'd rather not add it if its not fixing anything. I hate code that is
> there just because we have a fuzzy feeling it helps.
>
> So NACK unless it fixes something.
>
>  Luis

IMHO there is a right and wrong, at the very least inside a computer.
If we can't read the documentation (Documentation/memory-barriers.txt)
and decide if the patch is correct or incorrect (I'm not saying I can
with 100% certainty) then perhaps we should ask somebody who can?

BTW, I also hate code that is there just because somebody has a fuzzy
feeling it helps. We definitely don't need more of that. But I do like
code that is correct in principle, code that I can change and get a
predictable result. Code that works most of the time on most platforms
(as long as I don't make any changes) is no friend of mine.

/Björn
