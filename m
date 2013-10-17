Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3JQOgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:36:31 -0400
Message-ID: <1382020588.14410.12.camel@jlt4.sipsolutions.net> (sfid-20131017_163641_208221_00EA2D34)
Subject: Re: [PATCH 2/2] mac80211: store the channel in wdev upon ibss_join
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Thu, 17 Oct 2013 16:36:28 +0200
In-Reply-To: <1381790282-1146-2-git-send-email-antonio@meshcoding.com>
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
	 <1381790282-1146-2-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 00:38 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> To allow cfg80211 to use the real channel to pick up the
> proper (i)bss object, store the used channel in
> wdev->channel during ibss_join

WTF? No, mac80211 can't just randomly modify cfg80211-owned data.

johannes

