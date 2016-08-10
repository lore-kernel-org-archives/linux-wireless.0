Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34716 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbcHJSDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:03:17 -0400
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
Date: Wed, 10 Aug 2016 09:27:06 +0200
Message-ID: <4321952.1nMxxDi7Wz@positron.chronox.de> (sfid-20160810_232649_879788_FE53D5F9)
In-Reply-To: <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1526134.1iUazSISyZ@positron.chronox.de> <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 10. August 2016, 07:15:49 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> NIST SP 800-22-rev1a and NIST SP 800-90B are used together to evaluate the
> amount of min entropy the source provides, and not to decide if the source
> has passed the tests or failed. See
> 
> https://github.com/usnistgov/SP800-90B_EntropyAssessment
> 
> The goal is often to make sure the input entropy is more than the entropy we
> expect from the output.

You are correct on the SP800-90B tests (hence I did not refer to them for the 
binary decision). Yet, SP800-22 with the associated tool delivers a binary 
decision.

Ciao
Stephan
