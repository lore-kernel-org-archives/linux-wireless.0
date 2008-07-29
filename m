Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:63385 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYG2QYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 12:24:30 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1715319nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 09:24:28 -0700 (PDT)
Subject: Re: [PATCH 2/6] libertastf: header file
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1217172880.2700.28.camel@localhost.localdomain>
References: <4876383f.37322c0a.264b.2011@mx.google.com>
	 <1217172880.2700.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 18:24:23 +0200
Message-Id: <1217348663.6379.68.camel@localhost> (sfid-20080729_182433_665915_40CB68A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-27 at 11:34 -0400, Dan Williams wrote:
> On Thu, 2008-07-10 at 17:01 +0200, Luis Carlos Cobo wrote:
> > Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
> > Tested-by: Javier Cardona <javier@cozybit.com>
> 
> Any chance we could put it in
> 
> drivers/net/wireless/libertas_tf

No problem.

> Also, could you put it up in a git tree somewhere so I can help with
> merging the bits of libertas and libertas_tf that we can share to reduce
> the size of the patch?  Much of this file can be shared with libertas,
> including some of the command definitions, the RX and TX PDs, and some
> of the generic command structures.

Sounds good, I will set it up asap (tomorrow?) I need to fix a couple of
issues first, including the truncated license headers. Btw, note that I
was able to get rid of IPFIELD_ALIGN_OFFSET and simplify the code (since
we are receiving 802.11 frames and not 802.3 ones) we will have to make
it a variable, (evaluating to 2 for libertas and 0 for libertas_tf) to
share code.


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


