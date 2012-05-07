Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53596 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2EGJfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:35:46 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [trivial] nl80211: fix typos in comments
References: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Mon, 07 May 2012 12:35:41 +0300
In-Reply-To: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com>
	(Zefir Kurtisi's message of "Mon, 7 May 2012 11:21:59 +0200")
Message-ID: <87d36g9vv6.fsf@purkki.adurom.net> (sfid-20120507_113549_851799_74F1107A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> - * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
> - * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
> - * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
> + * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
> + * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
> + * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec

Are there any user space applications which use these enums? If there are,
this change will break them which is bad (tm).

-- 
Kalle Valo
