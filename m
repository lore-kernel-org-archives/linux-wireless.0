Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:45673 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSR7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 13:59:53 -0400
Date: Wed, 19 Jun 2013 19:59:39 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130619175939.GA19405@zenon.in.qult.net> (sfid-20130619_195955_907441_3050C61C)
References: <20130619115809.GA26717@zenon.in.qult.net>
 <51C1ACEC.2020703@rempel-privat.de>
 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
 <20130619140905.GA14079@zenon.in.qult.net>
 <1371651073.8349.19.camel@jlt4.sipsolutions.net>
 <51C1C95C.8030301@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C1C95C.8030301@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 05:08:12PM +0200, thus spake Oleksij Rempel:
> Ignacy wrote:
> >The station is unable to authenticate with WPA2 to the AP.  Interestingly
> >enough, if a monitor vif is created and upped beforehand, the authentication
> >succeeds.
> 
> which looks more like power management issue.  If monitore mode is
> enabled, no power sawing is done. But i use CFG80211_DEFAULT_PS=y on
> my system too and didn't had this issue. Even power_save=on is
> working. What else is different?
> 
> Ignacy, Is it RPi +  TL-WN722NC?

Yes, absolutely, but it happens on a Dell XPS 13" as well (Ubuntu 13.04).

-- 
P.S.  All information contained in the above letter is false,
      for reasons of military security.
