Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41737 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1LUSKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 13:10:50 -0500
Message-ID: <4EF22117.7070803@openwrt.org> (sfid-20111221_191053_355266_C441B075)
Date: Wed, 21 Dec 2011 19:10:31 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: mcgrof@infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] initvals: use SHA1 for verifying initval arrays
References: <1324470185-17886-1-git-send-email-juhosg@openwrt.org> <CAB=NE6WS6wasEEqFJ7RB7CMKYi=_RTjYJFRYLJc-_qq_-zJSuw@mail.gmail.com>
In-Reply-To: <CAB=NE6WS6wasEEqFJ7RB7CMKYi=_RTjYJFRYLJc-_qq_-zJSuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011.12.21. 18:02 keltezéssel, Luis R. Rodriguez írta:
> In the future you may want to do this for patches with a patch in the
> commit log:
> 
> $ cat csumtest.patch | awk '{print "\t"$0}'
> 
> As otherwise git will treat this as part of your patch.

Ok, I will do that next time.

> This is *really* *really* sexy, thanks, applied and pushed!

Thanks!

-Gabor
