Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43692 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932279AbcI0Oo2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 10:44:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] RANDOM: ATH9K RNG delivers zero bits of entropy
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1654172.XfclnXhRmn@positron.chronox.de>
References: <1654172.XfclnXhRmn@positron.chronox.de>
To: Stephan Mueller <smueller@chronox.de>
CC: Ted Tso <tytso@mit.edu>, <herbert@gondor.apana.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <ath9k-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
        <ath9k-devel@lists.ath9k.org>, Kalle Valo <kvalo@codeaurora.org>,
        "Jason Cooper" <jason@lakedaemon.net>
Message-ID: <2ba03f89daee4f09a88a1238943eb49d@euamsexm01a.eu.qualcomm.com> (sfid-20160927_164458_746698_CCF4A3B6)
Date: Tue, 27 Sep 2016 16:44:16 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
> The ATH9K driver implements an RNG which is completely bypassing the
> standard Linux HW generator logic.
> 
> The RNG may or may not deliver entropy. Considering the conservative
> approach in treating entropy with respect to non-auditable sources, this
> patch changes the delivered entropy value to zero. The RNG still feeds
> data into the input_pool but it is assumed to have no entropy.
> 
> When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
> the entropy estimation considering that a user can change that value at
> boot and runtime.
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Based on the discussion I'm dropping this patch. But the discussion was
hard to follow so please let me know if I misunderstood.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/9266265/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
