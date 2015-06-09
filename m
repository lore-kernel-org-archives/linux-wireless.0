Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54834 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbbFITwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:52:38 -0400
Message-ID: <1433879556.1892.19.camel@sipsolutions.net> (sfid-20150609_215241_491279_F4DE7CC3)
Subject: Re: [PATCH] mac80211: ignore invalid scan RSSI values
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Tue, 09 Jun 2015 21:52:36 +0200
In-Reply-To: <1433317457-6311-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1433317457-6311-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 10:44 +0300, Emmanuel Grumbach wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> Channels in 2.4GHz band overlap, this means that if we
> send a probe request on channel 1 and then move to channel
> 2, we will hear the probe response on channel 2. In this
> case, the RSSI will be lower than if we had heard it on
> the channel on which it was sent (1 in this case).
> 
> The scan result ignores those invalid values and the
> station last signal should not be updated as well.

Applied.

johannes

