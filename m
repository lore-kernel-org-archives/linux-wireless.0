Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50903 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaLXNSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 08:18:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
References: <1419271817.2317.12.camel@tiscali.nl>
Date: Wed, 24 Dec 2014 15:18:13 +0200
In-Reply-To: <1419271817.2317.12.camel@tiscali.nl> (Paul Bolle's message of
	"Mon, 22 Dec 2014 19:10:17 +0100")
Message-ID: <87tx0l9ofe.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_141843_183481_E740ED59)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Bolle <pebolle@tiscali.nl> writes:

> Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
> made it impossible to depend on CFG80211_WEXT. It does still allow to
> select that symbol. (Yes, the commit summary is confusing.)
>
> So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
> built again.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, applied to wireless-drivers.git.

-- 
Kalle Valo
