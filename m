Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0JGXTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:19:47 -0400
Subject: Re: [PATCH] wireless:  Set some stats used by /proc/net/wireless
 (wext)
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286493275-18364-1-git-send-email-greearb@candelatech.com>
References: <1286493275-18364-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 01:19:43 +0200
Message-ID: <1286493583.20974.54.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 16:14 -0700, greearb@candelatech.com wrote:

> @@ -468,6 +468,7 @@ struct rate_info {
>   * @tx_packets: packets transmitted to this station
>   * @tx_retries: cumulative retry counts
>   * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
> + * @rx_dropped_misc:  Dropped for un-specified reason.

also need to use/adjust "filled" throughout.

johannes

