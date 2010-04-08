Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36983 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab0DHH6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 03:58:15 -0400
Date: Thu, 8 Apr 2010 09:58:10 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Pavel Roskin <proski@gnu.org>, linux-crypto@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] crypto/testmgr: add testing for arc4 based on
 ecb(arc4)
Message-ID: <20100408075810.GA9722@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc>
 <1270621793.31184.50.camel@mj>
 <20100407092907.GB29993@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20100407092907.GB29993@gondor.apana.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Herbert Xu | 2010-04-07 17:29:07 [+0800]:

>Sebastian, how about precomputing the IV and provide them directly
>as a hex array?
>
>To test arc4_setup_iv itself, you can add an alg_test_arc4 function
>(like alg_test_crc32) that tests IV generation specifically.
>
>Alternatively, just add an alg_test_arc4 that computes the IV
>before calling alg_test_skcipher.

I take a look at this.

>Cheers,

Sebastian
