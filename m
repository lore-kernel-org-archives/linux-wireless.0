Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbcDZHEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 03:04:41 -0400
Message-ID: <1461654272.16188.4.camel@sipsolutions.net> (sfid-20160426_090444_956799_23A91988)
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Apr 2016 09:04:32 +0200
In-Reply-To: <5718EE7A.4030503@candelatech.com> (sfid-20160421_171514_734039_B1F3CF8F)
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
	 <5718EE7A.4030503@candelatech.com> (sfid-20160421_171514_734039_B1F3CF8F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-21 at 08:15 -0700, Ben Greear wrote:

> The thing is, it actually works just fine with the patch I posted
> to fix mac80211, and at any rate, even if the mac80211 patch isn't
> applied, the ath10k driver works just fine in HT mode.

This patch has no implications on HT, and I wasn't planning on applying
the mac80211 patch.

As I said, I have no objections to doing the (Broadcom) vendor specific
IEs for "VHT" in 2.4 GHz band, but I don't think we should advertise
the spec IEs when they're explicitly specified to be used only in the
5.2 GHz band.

johannes
