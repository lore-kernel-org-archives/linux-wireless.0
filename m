Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LPUou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 15:44:50 -0500
Message-ID: <1387226684.22195.5.camel@jlt4.sipsolutions.net> (sfid-20131216_214454_060623_50221B83)
Subject: Re: [PATCH v2 3.13] mac80211: move "bufferable MMPDU" check to fix
 AP mode scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 21:44:44 +0100
In-Reply-To: <1387226390-12551-1-git-send-email-nbd@openwrt.org>
References: <1387226390-12551-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 21:39 +0100, Felix Fietkau wrote:
> The check needs to apply to both multicast and unicast packets,
> otherwise probe requests on AP mode scans are sent through the multicast
> buffer queue, which adds long delays (often longer than the scanning
> interval).

Applied.

johannes

