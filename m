Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54538 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113AbcDEMgE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:36:04 -0400
Message-ID: <1459859759.18188.49.camel@sipsolutions.net> (sfid-20160405_143626_506691_CD95351D)
Subject: Re: [PATCH v3 2/2] mac80211: minstrel_ht: set A-MSDU tx limits
 based on selected max_prob_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Tue, 05 Apr 2016 14:35:59 +0200
In-Reply-To: <1457042341-72716-2-git-send-email-nbd@openwrt.org>
References: <1457042341-72716-1-git-send-email-nbd@openwrt.org>
	 <1457042341-72716-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied both now, I've had to fix a locking issue in the first patch.

I also worded the requirement for drivers more strongly - drivers
really *must* update the max length if they set the flag and don't use
minstrel.

johannes
