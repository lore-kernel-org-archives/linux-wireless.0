Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWPjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:39:11 -0400
To: Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH 2/2] mac80211: add =?UTF-8?Q?uapsd=5Fqueues=20and=20ma?=  =?UTF-8?Q?x=5Fsp=20params=20fields?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Tue, 23 Aug 2011 08:39:09 -0700
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <1314099467-20464-2-git-send-email-eliad@wizery.com>
 (sfid-20110823_133708_545470_04878AFD)
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
 <1314099467-20464-2-git-send-email-eliad@wizery.com>
 (sfid-20110823_133708_545470_04878AFD)
Message-ID: <ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 23 Aug 2011 14:37:47 +0300, Eliad Peller wrote:
> Add uapsd_queues and max_sp fields to ieee80211_sta.
> These fields might be needed by low-level drivers in
> order to configure the AP.

So your device has uapsd built-in? What if a device doesn't -- do we 
need feature advertisement for this?

johannes
