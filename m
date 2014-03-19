Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSODS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:03:18 -0400
Message-ID: <1395237793.4142.12.camel@jlt4.sipsolutions.net> (sfid-20140319_150321_637455_CAFE1607)
Subject: Re: [PATCH] mac80211: add status_driver_data array to
 ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Wed, 19 Mar 2014 15:03:13 +0100
In-Reply-To: <1394713847-12397-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1394713847-12397-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-13 at 14:30 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Drivers might want to have private data in addition
> to all other ieee80211_tx_info.status fields.
> 
> The current ieee80211_tx_info.rate_driver_data overlaps
> with some of the non-rate data (e.g. ampdu_ack_len), so
> it might not be good enough.
> 
> Since we already know how much free bytes remained,
> simply use this size to define (void *) array.
> 
> While on it, change ack_signal type from int to the more
> explicit s32 type.

Applied.

johannes

