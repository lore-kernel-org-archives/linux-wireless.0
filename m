Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2LGMJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 07:09:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tgwk2-00035V-92
	for linux-wireless@vger.kernel.org; Fri, 07 Dec 2012 13:09:19 +0100
Message-ID: <1354882181.9552.8.camel@jlt4.sipsolutions.net> (sfid-20121207_130923_470563_7F58B455)
Subject: Re: [RFC] mac80211: restrict assoc request VHT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 07 Dec 2012 13:09:41 +0100
In-Reply-To: <1354882131-1538-1-git-send-email-johannes@sipsolutions.net> (sfid-20121207_130833_842267_2AFBC1B4)
References: <1354882131-1538-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121207_130833_842267_2AFBC1B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 13:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In interoperability testing some APs showed bad behaviour
> if some of the VHT capabilities of the station are better
> than their own. Restrict the assoc request parameters
>  - beamformee capabable,
>  - RX STBC and
>  - RX MCS set
> to the subset that the AP can support.

This feels somewhat unclean to me ... I'm not sure if any of these APs
are on the market, but I'm not sure we'll be able to easily figure that
out :(

johannes

