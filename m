Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49995 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab0JIPYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 11:24:06 -0400
Message-ID: <4CB0890D.3050208@openwrt.org>
Date: Sat, 09 Oct 2010 17:23:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>	<20101005131744.GB4074@tuxdriver.com>	<20101005195039.GD11831@tux> <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
In-Reply-To: <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-09 5:19 PM, Björn Smedman wrote:
> On Tue, Oct 5, 2010 at 9:50 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Felix is more familiar with this area so I'll let him chime with
>> his ACK/NACK.
>>
>>  Luis
> 
> So Felix, what do you think? I realize it may not be a common problem
> on any currently popular platform, but don't you agree it is in
> principle unsafe to write to the ds_link field of dma descriptors
> without a guarantee that those writes will be performed in the
> intended order?
Haven't had time to review this in detail yet. I'll take another look at
it later...

- Felix
