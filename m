Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46164 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbBXXYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 18:24:41 -0500
Received: by mail-ob0-f180.google.com with SMTP id vb8so246441obc.11
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 15:24:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424808508.2192.38.camel@sipsolutions.net>
References: <CAFk-A4=OJyzuQ04i=c5F2HpX+n8JK6RSbZrNKGU7M6J8EteH8w@mail.gmail.com>
	<1424785336-3268-1-git-send-email-masashi.honma@gmail.com>
	<1424808508.2192.38.camel@sipsolutions.net>
Date: Wed, 25 Feb 2015 08:24:41 +0900
Message-ID: <CAFk-A4kLVXHH1eXow+56TquoaiVpTjS70Sb71+-xtgpJHdBRSw@mail.gmail.com> (sfid-20150225_002444_962664_C0788B86)
Subject: Re: [PATCH v5] mac80211: Allow 0 for NL80211_MESHCONF_PLINK_TIMEOUT
 to disable STA expiration
From: Masashi Honma <masashi.honma@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-25 5:08 GMT+09:00 Johannes Berg <johannes@sipsolutions.net>:
> Applied, I've reworded and rewrapped the commit log - in the future
> please send commit logs with at most 72 characters per line.

Thanks. I will remember 72 characters rule.
