Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37824 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaE1ODd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:03:33 -0400
Message-ID: <1401285802.8146.22.camel@jlt4.sipsolutions.net> (sfid-20140528_160335_701668_A485B6DC)
Subject: Re: [PATCH] mac80211: reduce packet loss notifications under load
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 May 2014 16:03:22 +0200
In-Reply-To: <1400868328-78595-1-git-send-email-nbd@openwrt.org>
References: <1400868328-78595-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 20:05 +0200, Felix Fietkau wrote:
> During strong signal fluctuations under high throughput, few consecutive
> failed A-MPDU transmissions can easily trigger packet loss notification,
> and thus (in AP mode) client disconnection.
> 
> Reduce the number of false positives by checking the A-MPDU status flag
> and treating a failed A-MPDU as a single packet.

APplied.

johannes

