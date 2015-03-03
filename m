Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:39263 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932398AbbCCTDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 14:03:22 -0500
Message-ID: <1425409397.17273.38.camel@perches.com> (sfid-20150303_200417_634300_617152E0)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 11:03:17 -0800
In-Reply-To: <20150303.135737.630359651880852880.davem@davemloft.net>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <20150303.135737.630359651880852880.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 13:57 -0500, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 03 Mar 2015 09:16:57 +0100
> 
> > Other than that, I guess I'll apply this, but I really wish there was a
> > way to distinguish more easily which of these require alignment and
> > which don't.
> 
> You can't apply "this" without the dependency patch #1.
> 
> Therefore this should probably all go through my tree.

Hey David.

The eth_<foo>_addr functions already exist so
1/14 isn't a dependency.

It's just a trivial improvement on existing code
with CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS and
at least the arm 4.6.3 compiler.


