Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab1FPPem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 11:34:42 -0400
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: [PATCH v2 00/27] mac80211: create =?UTF-8?Q?mac=38=30=32=31?=  =?UTF-8?Q?=31=5F=20prefix?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Thu, 16 Jun 2011 17:34:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
 (sfid-20110614_003439_038660_03C7EB76)
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
 (sfid-20110614_003439_038660_03C7EB76)
Message-ID: <1f42877e8c429b956640a6e9d97127fc@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 14 Jun 2011 01:34:28 +0300, Kalle Valo wrote:
> It has always annoyed me that mac80211 uses ieee80211_ prefix. For 
> some time
> already I have been planning to try to do something about it and 
> finally I
> started it. Here's my first shot at it.
>
> In this patchset I first fix some issues I found from the drivers, 
> then
> create mac80211-compat.h to make the transition as smooth as possible 
> and
> then start changing mac80211 itself.

FWIW, I don't mind the rename, but I don't like the compat.h thing. The 
transition won't be smoothed by this, it just means the transition will 
drag out as things conflict etc. If we want to rename, we'll need to 
bite the bullet eventually anyway.

johannes
