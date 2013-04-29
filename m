Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3D2OWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 10:22:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UWoy4-0007E8-Bj
	for linux-wireless@vger.kernel.org; Mon, 29 Apr 2013 16:22:12 +0200
Message-ID: <1367245330.8289.4.camel@jlt4.sipsolutions.net> (sfid-20130429_162218_495191_134D9EA1)
Subject: Re: [PATCH] mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 29 Apr 2013 16:22:10 +0200
In-Reply-To: <1367242207-28671-1-git-send-email-johannes@sipsolutions.net> (sfid-20130429_153025_106505_50F144FC)
References: <1367242207-28671-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130429_153025_106505_50F144FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 15:30 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since commit 12e7f517029dad819c45eca9ca01fdb9ba57616b,
> IEEE80211_SDATA_DISCONNECT_RESUME no longer worked as
> it would simply never be tested. Restore a bit of the
> code removed there and in 9b7d72c1041ec5b20b24af487a9
> to make it work again.

Tested & applied :)

johannes

