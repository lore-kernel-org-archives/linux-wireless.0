Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IKMm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 08:42:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TBPnt-0006lG-K0
	for linux-wireless@vger.kernel.org; Tue, 11 Sep 2012 14:42:57 +0200
Message-ID: <1347367415.4683.0.camel@jlt4.sipsolutions.net> (sfid-20120911_144301_252033_82F46D22)
Subject: Re: [PATCH] mac80211: remove unneeded CONFIG_PM ifdef
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 11 Sep 2012 14:43:35 +0200
In-Reply-To: <1347350383-23349-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_095912_518897_A3019C15)
References: <1347350383-23349-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120911_095912_518897_A3019C15)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-11 at 09:59 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The functions are only called if CONFIG_PM is set
> as the callers are under an ifdef, so there's no
> need to also define no-op functions.

Applied.

johannes

