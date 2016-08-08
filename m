Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43521 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbcHHP0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 11:26:13 -0400
Date: Mon, 8 Aug 2016 23:26:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	tom@herbertland.com
Subject: Re: Buggy rhashtable walking
Message-ID: <20160808152603.GB31570@gondor.apana.org.au> (sfid-20160808_172617_468279_3E12CA4B)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
 <20160805104858.GA9297@gondor.apana.org.au>
 <1470394233.2977.37.camel@sipsolutions.net>
 <57A47CA3.4010101@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57A47CA3.4010101@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2016 at 04:46:43AM -0700, Ben Greear wrote:
>
> It would not be fun to have to revert to the old way of hashing
> stations in mac80211...
> 
> I'll be happy to test the patches when you have them ready.

Thanks for the offer.  Unfortunately it'll be a few days before
I'm ready because I need to work through some crypto patches first.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
