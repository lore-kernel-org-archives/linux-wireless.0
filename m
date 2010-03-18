Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29037 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0CRQAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 12:00:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 09:00:36 -0700
Date: Thu, 18 Mar 2010 09:00:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: selvam <sathakselva@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vipin M <vipintm@gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: 4ms frame length table update
Message-ID: <20100318160034.GC2269@tux>
References: <1aee2dca1003172337g5d66a03ex20ebab74707a6c56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1aee2dca1003172337g5d66a03ex20ebab74707a6c56@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 11:37:29PM -0700, selvam wrote:
> Hi,
> 
> The 4 ms frame length table is updated to support up to MCS 31.
> 
> These values are calculated based on the equation 9.1 from the IEEE 802.11n standard.
> These values are rounded off to multiple of 4 bytes. If the final value is greater than 65535 then it is changed to 65532, since the maximum A-MPDU length is 65535 bytes.

Thanks for this patch, but can you elaborate on what your patch does other
than the above. For example, you may want to mention that although the current
ath9k driver does not support up to MCS31 your patch would enable such support
for future chipsets which could be supported. You also forgot to Signed-off-by
it, and provide a clearer commit log entry. Check git log for examples on
wireless-testing, also read:

http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
http://wireless.kernel.org/en/developers/Documentation

  Luis
