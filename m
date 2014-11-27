Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61311 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaK0PA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 10:00:28 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so6695722wgh.39
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 07:00:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417099707.19919.0.camel@sipsolutions.net>
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1417099707.19919.0.camel@sipsolutions.net>
Date: Thu, 27 Nov 2014 16:00:26 +0100
Message-ID: <CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com> (sfid-20141127_160034_733176_24F13AE4)
Subject: Re: [PATCH] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2014-11-27 at 14:39 +0100, Lorenzo Bianconi wrote:
>> Configure per packet Transmit Power Control (TPC) in lower drivers checking
>> if user_power_level has been set to IEEE80211_UNSET_POWER_LEVEL
>
> Err, what? Why? how? what does this do?
>
> johannes
>

I would like to enable TPC in ath9k using iw command:

iw dev wlan0 set txpower auto

I knew user_power_level is set to IEEE80211_UNSET_POWER_LEVEL in that
case. Is there a better way than to check user_power_level?

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
