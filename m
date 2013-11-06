Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3KFKMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:12:09 -0500
Message-ID: <1383732726.14307.19.camel@jlt4.sipsolutions.net> (sfid-20131106_111213_128403_E95685E7)
Subject: Re: [PATCH v2 4/5] cfg80211: DFS check chandef usable before CAC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:12:06 +0100
In-Reply-To: <1383659329-11023-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144904_921666_812953A6)
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1383659329-11023-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_144904_921666_812953A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
> Check chandef we get in CAC request is usable for CAC.
> All channels have to be DFS channels. Allow DFS_USABLE
> and DFS_AVAILABLE channels mix. At least one channel
> has to be DFS_USABLE (require CAC).

Applied 3 and 4 too, to mac80211-next.

johannes

