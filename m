Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22242 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbIQK6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 06:58:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3 1/3] ath10k: enable monitor when OTHER_BSS requested
References: <1441817256-3997-1-git-send-email-me@bobcopeland.com>
Date: Thu, 17 Sep 2015 13:57:51 +0300
In-Reply-To: <1441817256-3997-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Wed, 9 Sep 2015 12:47:34 -0400")
Message-ID: <87d1xhuxcg.fsf@kamboji.qca.qualcomm.com> (sfid-20150917_125812_555620_1DF36C41)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> By default, ath10k restricts received frames to those matching BSSID.
> When other BSS frames are requested (e.g. in mesh mode), add an internal
> monitor device so those frames are not filtered.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, all three patches applied. In patch 3 I just changed the
firmware version in commit log to 10.2.4.70.6-2 as that one has the raw
mode feature flag enabled.

I also tested this myself and I was able to join to a mesh network I
created with ath9k and ping each other. In case someone cherry picks
these patches please take into account that these patches need quite a
few recent mac80211 patches from mac80211-next. The patches are also in
wireless-testing and ath.git master branch. Safest is to test with
ath.git master branch.

-- 
Kalle Valo
