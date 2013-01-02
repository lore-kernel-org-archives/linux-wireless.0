Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3ABKxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:53:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLxD-0004HF-Ef
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:53:47 +0100
Message-ID: <1357124053.9839.6.camel@jlt4.sipsolutions.net> (sfid-20130102_115351_138203_DEB24E57)
Subject: Re: [PATCH] cfg80211: disallow more station changes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:54:13 +0100
In-Reply-To: <1356626113-22698-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_173523_486460_2DBF2FDA)
References: <1356626113-22698-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121227_173523_486460_2DBF2FDA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 17:35 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The following changes are invalid and should be
> disallowed when a station already exists:
>  * supported rates changes, except for TDLS peers
>  * listen interval changes
>  * HT capability changes
> 
> Disallow them and also update a mac80211 comment
> explaining how they would be racy.

Applied.

johannes

