Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57934 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSPIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:08:16 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Ls6Bl-1UAiy91y8N-013vkY for
 <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 17:08:14 +0200
Message-ID: <51C1C95C.8030301@rempel-privat.de> (sfid-20130619_170820_157825_1BF87D26)
Date: Wed, 19 Jun 2013 17:08:12 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ignacy Gawedzki <i@lri.fr>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
References: <20130619115809.GA26717@zenon.in.qult.net>  <51C1ACEC.2020703@rempel-privat.de>  <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>  <51C1B467.1030509@rempel-privat.de>  <20130619140905.GA14079@zenon.in.qult.net>  (sfid-20130619_160921_593309_5728C3A1) <1371651073.8349.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371651073.8349.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 19.06.2013 16:11, schrieb Johannes Berg:
> Btw, I'm a bit confused -- are you using ath9k_htc as per the subject,
> or ath9k?
>
> if it's ath9k_htc then I don't really understand why the patch that
> *fixed* it for Corey *broke* it for you?
>
> johannes

It will be interesting to get some more info from Corey, about his 
wireless setup.


Ignacy wrote:
> The station is unable to authenticate with WPA2 to the AP.  Interestingly
> enough, if a monitor vif is created and upped beforehand, the authentication
> succeeds.

which looks more like power management issue.  If monitore mode is 
enabled, no power sawing is done. But i use CFG80211_DEFAULT_PS=y on my 
system too and didn't had this issue. Even power_save=on is working. 
What else is different?

Ignacy, Is it RPi +  TL-WN722NC?

-- 
Regards,
Oleksij
