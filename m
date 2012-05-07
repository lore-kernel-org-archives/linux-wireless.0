Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41855 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab2EGJqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:46:52 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [trivial] nl80211: fix typos in comments
References: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com>
	<87d36g9vv6.fsf@purkki.adurom.net>
	<1336383672.4325.8.camel@jlt3.sipsolutions.net>
Date: Mon, 07 May 2012 12:46:50 +0300
In-Reply-To: <1336383672.4325.8.camel@jlt3.sipsolutions.net> (Johannes Berg's
	message of "Mon, 07 May 2012 11:41:12 +0200")
Message-ID: <878vh49vcl.fsf@purkki.adurom.net> (sfid-20120507_114655_924663_23CB0FD7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2012-05-07 at 12:35 +0300, Kalle Valo wrote:
>> Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:
>> 
>> > - * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
>> > - * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
>> > - * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
>> > + * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
>> > + * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
>> > + * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
>> 
>> Are there any user space applications which use these enums? If there are,
>> this change will break them which is bad (tm).
>
> No, it actually just fixes kernel-doc .. the constant names are spelled
> wrong in the comment.

Hah, I was blind again. I blame Monday morning for this ;)

Sorry for the noise.

-- 
Kalle Valo
