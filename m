Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaBUIxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:53:48 -0500
Message-ID: <1392972825.4346.38.camel@jlt4.sipsolutions.net> (sfid-20140221_095352_597582_AA4C24D4)
Subject: Re: [PATCH 3/4] cfg80211/mac80211: DFS pass CAC time as a parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Fri, 21 Feb 2014 09:53:45 +0100
In-Reply-To: <1392231266-28479-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195455_207327_295DFD80)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1392231266-28479-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140212_195455_207327_295DFD80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regarding the subject, the '/mac80211' part should probably not be there
since it's just an API update and the real change is in cfg80211.

johannes

