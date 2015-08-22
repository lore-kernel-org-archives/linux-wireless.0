Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:48959 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbbHVIw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 04:52:58 -0400
Message-ID: <55D83868.1090800@msgid.tls.msk.ru> (sfid-20150822_105300_774072_6EA673DA)
Date: Sat, 22 Aug 2015 11:52:56 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-only "freshness" auth problem??
References: <55D6F0DB.5050505@msgid.tls.msk.ru> <CACna6rxtaq8LOeY3+c3ThBgjNya6f2Kqm8At9_DKVZHYYRg0iA@mail.gmail.com> <55D83809.7040305@tls.msk.ru>
In-Reply-To: <55D83809.7040305@tls.msk.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

22.08.2015 11:51, Michael Tokarev wrote:

> Here are the main difference (- for bad, + for good):
>
>   nl80211: Association request send successfully
> -nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan0
> -nl80211: Delete station c0:4a:00:49:1b:f2
>   nl80211: Drv Event 38 (NL80211_CMD_ASSOCIATE) received for wlan0
> -nl80211: MLME event 38; timeout with c0:4a:00:49:1b:f2
> -wlan0: Event ASSOC_TIMED_OUT (15) received
> -wlan0: SME: Association timed out
> -wlan0: Radio work 'sme-connect'@0x7fbf84e5a700 done in 0.137132 seconds
> ...
>
> So in "good" case, there's one event, CMD_DEL_STATION, received
> right before the CMD_ASSOTIATE.  The rest look similar besides a
> few probably irrelevant details (timings, frequency, etc).

In "bad" case ofcourse :)

Thanks!

/mjt
