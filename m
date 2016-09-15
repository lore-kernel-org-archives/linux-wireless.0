Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51023 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933845AbcIOINs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 04:13:48 -0400
Message-ID: <1473927224.4423.37.camel@sipsolutions.net> (sfid-20160915_101410_440646_D19B7FC3)
Subject: Re: [PATCH v2] mac80211: allow driver to handle packet-loss
 mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Thu, 15 Sep 2016 10:13:44 +0200
In-Reply-To: <20160914071832.11465-1-rmanohar@qti.qualcomm.com>
References: <20160914071832.11465-1-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-14 at 12:48 +0530, Rajkumar Manoharan wrote:
> Based on consecutive msdu failures, mac80211 triggers CQM packet-loss
> mechanism. Drivers like ath10k that have its own connection
> monitoring
> algorithm, offloaded to firmware for triggering station kickout. In
> case
> of station kickout, driver will report low ack status by mac80211 API
> (ieee80211_report_low_ack).
> 
> This flag will enable the driver to completely rely on firmware
> events
> for station kickout and bypass mac80211 packet loss mechanism.
> 
applied.

johannes
