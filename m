Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3LPLOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 06:14:37 -0500
Message-ID: <1387192471.4665.14.camel@jlt4.sipsolutions.net> (sfid-20131216_121441_277033_D112B2B7)
Subject: Re: [PATCH] mac80211: let the driver reserve extra tailroom in
 beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 12:14:31 +0100
In-Reply-To: <1387025693-87897-1-git-send-email-nbd@openwrt.org>
References: <1387025693-87897-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-12-14 at 13:54 +0100, Felix Fietkau wrote:
> Can be used to add extra IEs (such as P2P NoA) without having to
> reallocate the buffer.

Applied.

johannes

