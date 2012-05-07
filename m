Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2EGJlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:41:17 -0400
Message-ID: <1336383672.4325.8.camel@jlt3.sipsolutions.net> (sfid-20120507_114133_031091_33C319C0)
Subject: Re: [PATCH] [trivial] nl80211: fix typos in comments
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 11:41:12 +0200
In-Reply-To: <87d36g9vv6.fsf@purkki.adurom.net> (sfid-20120507_113549_851799_74F1107A)
References: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com>
	 <87d36g9vv6.fsf@purkki.adurom.net> (sfid-20120507_113549_851799_74F1107A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 12:35 +0300, Kalle Valo wrote:
> Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:
> 
> > - * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
> > - * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
> > - * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
> > + * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
> > + * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
> > + * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
> 
> Are there any user space applications which use these enums? If there are,
> this change will break them which is bad (tm).

No, it actually just fixes kernel-doc .. the constant names are spelled
wrong in the comment.

johannes

