Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab2INMGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:06:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TCUep-0006Eo-GJ
	for linux-wireless@vger.kernel.org; Fri, 14 Sep 2012 14:06:03 +0200
Message-ID: <1347624398.4060.0.camel@jlt4.sipsolutions.net> (sfid-20120914_140858_693676_61C0F4DA)
Subject: Re: [PATCH] mac80211: handle power constraint/country IE better
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 14:06:38 +0200
In-Reply-To: <1347367364-16642-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_144214_003264_1C6B0911)
References: <1347367364-16642-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120911_144214_003264_1C6B0911)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-11 at 14:42 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently, mac80211 uses the power constraint IE, and reduces
> the regulatory max TX power by it. This can cause issues if
> the AP is advertising a large power constraint value matching
> a high TX power in its country IE, for example in this case:
> 
> ...
> Country: US  Environment: Indoor/Outdoor
>     ...
>     Channels [157 - 157] @ 30 dBm
>     ...
> Power constraint: 13 dB
> ...

Applied.

johannes

