Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:44384 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab2EGJpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:45:14 -0400
Message-ID: <4FA799A7.9020101@neratec.com> (sfid-20120507_114519_749905_9DF05870)
Date: Mon, 07 May 2012 11:45:11 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@adurom.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [trivial] nl80211: fix typos in comments
References: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com>  <87d36g9vv6.fsf@purkki.adurom.net> (sfid-20120507_113549_851799_74F1107A) <1336383672.4325.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336383672.4325.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 11:41 AM, Johannes Berg wrote:
> On Mon, 2012-05-07 at 12:35 +0300, Kalle Valo wrote:
>> Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:
>>
>>> - * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
>>> - * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
>>> - * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
>>> + * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
>>> + * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
>>> + * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
>>
>> Are there any user space applications which use these enums? If there are,
>> this change will break them which is bad (tm).
> 
> No, it actually just fixes kernel-doc .. the constant names are spelled
> wrong in the comment.
> 
> johannes
> 
Yep, 'trivial' since only C&P typos fixed. Or is there a better tag for
non functional modifications (comments, indentation, etc.)?
