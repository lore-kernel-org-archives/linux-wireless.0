Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:48:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TavgW-0003Q0-1Y
	for linux-wireless@vger.kernel.org; Tue, 20 Nov 2012 22:48:48 +0100
Message-ID: <1353448154.9399.22.camel@jlt4.sipsolutions.net> (sfid-20121120_224852_125243_B3326468)
Subject: Re: [PATCH 00/10] initial VHT support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 20 Nov 2012 22:49:14 +0100
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224451_615250_64DF204A)
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121120_224451_615250_64DF204A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 22:45 +0100, Johannes Berg wrote:
> Ok, so here's a repost of the VHT support. I've had to work on
> the compatibility code (since I needed it in hostapd as well),
> so that's new. Other than that, not many changes over the last
> version.
> 
> I now tested that the channel settings go through to the driver
> (i.e. hwsim) for both monitor mode and AP mode. Managed mode
> still needs mac80211 work to parse the VHT operation IE and set
> the channel context accordingly, I plan to work on that soon.
> 
> This also still needs regulatory work (TODO in the code) but as
> we don't have any drivers we don't have to worry about it yet.
> 
> I'm planning to merge this soon so everybody can work with the
> new APIs and more people can contribute the missing pieces.

Oh, there's also a bit of iw code in the "vht" branch.

johannes

