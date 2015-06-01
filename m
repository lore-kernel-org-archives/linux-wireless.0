Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58427 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbbFAPhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 11:37:07 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/7] mac80211: Switch to new AEAD interface
Date: Mon, 01 Jun 2015 17:36:58 +0200
Message-ID: <2613062.1qx4rgqk9F@tauon> (sfid-20150601_173712_248391_92D48588)
In-Reply-To: <1433169326.3505.12.camel@sipsolutions.net>
References: <20150521103938.GA23035@gondor.apana.org.au> <1433167519.3505.11.camel@sipsolutions.net> <1433169326.3505.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Juni 2015, 16:35:26 schrieb Johannes Berg:

Hi Johannes,

>
>IOW, I think something like this would make sense:
>

That looks definitely cleaner :-)

Though, my main concern was just to ensure that the aad length value is not 
zero.


Ciao
Stephan
