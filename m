Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBUIXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:23:23 -0500
Message-ID: <1392970995.4346.15.camel@jlt4.sipsolutions.net> (sfid-20140221_092326_978312_3C3B56C8)
Subject: Re: [PATCH] cfg80211: regulatory, introduce NL80211_RRF_AUTO_BW
 rule flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Fri, 21 Feb 2014 09:23:15 +0100
In-Reply-To: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140220_135226_626718_D0F21CF1)
References: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140220_135226_626718_D0F21CF1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 13:52 +0100, Janusz Dziedzic wrote:
> Introduce NL80211_RRF_AUTO_BW rule flag. If this flag set
> maximum available bandwidth should be calculated base on
> contiguous rules and wider channels will be allowed to cross
> multiple contiguous/overlapping frequency ranges.
> 
> In case of old kernels maximum bandwidth from regulatory
> rule will be used, while there is no NL80211_RRF_AUTO_BW flag.

Applied, thanks. I made the snrptinf() code use sizeof() instead of
hardcoding the size twice.

johannes

