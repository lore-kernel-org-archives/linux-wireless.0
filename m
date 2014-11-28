Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41309 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaK1NZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:25:40 -0500
Message-ID: <1417181118.27562.5.camel@sipsolutions.net> (sfid-20141128_142543_205716_571DFBE4)
Subject: Re: [PATCH] mac80211: add more missing checks for VHT tx rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Fri, 28 Nov 2014 14:25:18 +0100
In-Reply-To: <1416608954-84560-1-git-send-email-nbd@openwrt.org>
References: <1416608954-84560-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 23:29 +0100, Felix Fietkau wrote:
> Fixes a crash on attempting to calculate the frame duration for a VHT
> packet (which needs to be handled by hw/driver instead).

Applied, thanks.

johannes

