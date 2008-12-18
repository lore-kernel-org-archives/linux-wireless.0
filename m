Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39537 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYLRVZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:25:05 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mac80211: enable IEEE80211_CONF_PS only when associated
References: <20081218211532.6842.88104.stgit@tikku>
	<20081218211658.6842.99133.stgit@tikku>
	<1229635297.3601.45.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 18 Dec 2008 23:24:39 +0200
In-Reply-To: <1229635297.3601.45.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 18 Dec 2008 22\:21\:37 +0100")
Message-ID: <87prjp89d4.fsf@nokia.com> (sfid-20081218_222509_301771_D5D009E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2008-12-18 at 23:16 +0200, Kalle Valo wrote:
>
>> +	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>> +		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>> +		config_changed |= IEEE80211_CONF_PS;
>
> IEEE80211_CONF_CHANGE_PS

Will fix in v6.

> other than that,
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

-- 
Kalle Valo
