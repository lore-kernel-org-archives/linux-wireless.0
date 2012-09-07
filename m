Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2IGISv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:18:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9tm6-0004wY-Iw
	for linux-wireless@vger.kernel.org; Fri, 07 Sep 2012 10:18:51 +0200
Message-ID: <1347005968.4256.4.camel@jlt4.sipsolutions.net> (sfid-20120907_101855_294730_747BC5D4)
Subject: Re: [PATCH] mac80211: check power constraint IE size when parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:19:28 +0200
In-Reply-To: <1346944279-18196-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_171048_580446_BF2F27EF)
References: <1346944279-18196-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120906_171048_580446_BF2F27EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 17:11 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The power constraint IE is always a single byte
> so check the size when parsing instead of later.

Applied.


