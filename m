Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0KETvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:51:00 -0400
To: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC 05/15] nl80211: call =?UTF-8?Q?periodic=5Fstart=20and=20periodic?=
 =?UTF-8?Q?=5Fstop?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Nov 2010 20:50:59 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <1288986286.25600.0.camel@powerslave>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com> <1288612336-2830-6-git-send-email-luciano.coelho@nokia.com> <1288885449.3659.2.camel@jlt3.sipsolutions.net> <1288986286.25600.0.camel@powerslave>
Message-ID: <d0856233021ba3439c3d31dd53e70f24@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 05 Nov 2010 21:44:46 +0200, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
>> Need to advertise these too in the wiphy cmd nl80211.
> 
> Yeps! Will do.

add a flag for it too so cfg80211 will advertise
it only for mac80211 drivers that support it, like
I did in 

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/026-nl80211-p2p-apis.patch

johannes
