Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37520 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdBFJEj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 04:04:39 -0500
Message-ID: <1486371873.14226.8.camel@sipsolutions.net> (sfid-20170206_100647_162824_79A7DB33)
Subject: Re: [PATCH] mac80211: Allocate a sync skcipher explicitly for FILS
 AEAD
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 06 Feb 2017 10:04:33 +0100
In-Reply-To: <20170206090039.GA9467@gondor.apana.org.au>
References: <1486224522-26392-1-git-send-email-jouni@qca.qualcomm.com>
         <1486364077.14226.1.camel@sipsolutions.net>
         <20170206090039.GA9467@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The type and mask are used as follows when checking an algorithm:
> 
> 	alg->type & mask == type & mask
> 
> So to request a synchronous algorithm (that is, one with the
> CRYPTO_ALG_ASYNC bit set to zero), you would set type to 0 and
> mask to CRYPTO_ALG_ASYNC.

Ah. Ok, that makes sense, thanks for the explanation.

johannes
