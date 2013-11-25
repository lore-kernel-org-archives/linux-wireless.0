Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KYPz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 10:55:26 -0500
Message-ID: <1385394924.4443.25.camel@jlt4.sipsolutions.net> (sfid-20131125_165529_722538_4D92BFE2)
Subject: Re: [PATCH 3.13] cfg80211: ignore supported rates for nonexistant
 bands on scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 16:55:24 +0100
In-Reply-To: <1384972841-34929-1-git-send-email-nbd@openwrt.org>
References: <1384972841-34929-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 19:40 +0100, Felix Fietkau wrote:
> Fixes wpa_supplicant p2p_find on 5GHz-only devices

Applied. Not that your scenario really makes sense, but hey :)

johannes

