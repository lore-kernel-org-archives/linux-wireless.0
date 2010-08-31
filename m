Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0HaSKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 14:10:35 -0400
Subject: Re: [PATCH] wireless: register wiphy rfkill w/o holding
 cfg80211_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Miles Lane <miles.lane@gmail.com>,
	rjw@sisk.pl, maciej.rutecki@gmail.com
In-Reply-To: <1283277436-5922-1-git-send-email-linville@tuxdriver.com>
References: <1283237477.3733.0.camel@jlt3.sipsolutions.net>
	 <1283277436-5922-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 20:10:32 +0200
Message-ID: <1283278232.3733.53.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 13:57 -0400, John W. Linville wrote:
> Otherwise lockdep complains...
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=17311
...

> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks John.

johannes

