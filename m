Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1HWPzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:55:03 -0400
To: Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH 2/2] mac80211: add =?UTF-8?Q?uapsd=5Fqueues=20and=20ma?=  =?UTF-8?Q?x=5Fsp=20params=20fields?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Tue, 23 Aug 2011 08:55:01 -0700
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <CAB3XZEcqwZxYYEcVrHcnCwBBS-z505yOoy2y8PjGxRSsnZp8Uw@mail.gmail.com>
 (sfid-20110823_175117_049759_EDE4D14E)
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
 <1314099467-20464-2-git-send-email-eliad@wizery.com>
 <ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
 <CAB3XZEcqwZxYYEcVrHcnCwBBS-z505yOoy2y8PjGxRSsnZp8Uw@mail.gmail.com>
 (sfid-20110823_175117_049759_EDE4D14E)
Message-ID: <25d525ade5d006352bd7615ba5c98aa1@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 23 Aug 2011 18:50:44 +0300, Eliad Peller wrote:
> basically these params come from the supplicant on sta addition.
> if the ap wasn't configured with uapsd, there won't be
> NL80211_ATTR_STA_WME attribute, and these fields will be 0.
>
> devices with no uapsd support will ignore these fields.
> am i missing something?

Well, so, how will the user know whether the device supports uAPSD? Or, 
if the user asks hostapd to enable uAPSD, how will hostapd know if the 
device supports it or not?

johannes
