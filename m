Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34728 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936493AbcHJSiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:38:17 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 08:51:50 +0200
Message-ID: <1526134.1iUazSISyZ@positron.chronox.de> (sfid-20160810_203903_657131_8A09EEA6)
In-Reply-To: <82844e4b56c9475fabf22b3fe12b53bb@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <14565196.xaXq375WQg@tauon.atsec.com> <82844e4b56c9475fabf22b3fe12b53bb@aptaiexm02f.ap.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 10. August 2016, 06:46:31 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> Would you please provide a recent NIST document which asks the entropy
> source to pass the NIST randomness tests ?

See FIPS 140-2 IG 7.15 which explicitly references SP800-22.

Ciao
Stephan
