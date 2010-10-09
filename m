Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63708 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0JIPTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 11:19:52 -0400
Received: by iwn6 with SMTP id 6so1512556iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 08:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101005195039.GD11831@tux>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
	<20101005131744.GB4074@tuxdriver.com>
	<20101005195039.GD11831@tux>
Date: Sat, 9 Oct 2010 17:19:51 +0200
Message-ID: <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 9:50 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Felix is more familiar with this area so I'll let him chime with
> his ACK/NACK.
>
>  Luis

So Felix, what do you think? I realize it may not be a common problem
on any currently popular platform, but don't you agree it is in
principle unsafe to write to the ds_link field of dma descriptors
without a guarantee that those writes will be performed in the
intended order?

/Björn
