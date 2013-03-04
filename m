Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab3CDPGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:06:22 -0500
Message-ID: <1362409577.21028.13.camel@jlt4.sipsolutions.net> (sfid-20130304_160626_279352_8FFD67E4)
Subject: Re: [PATCH 1/3] minstrel_ht: improve accuracy of throughput metric
 at high data rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:06:17 +0100
In-Reply-To: <1362255614-30859-1-git-send-email-nbd@openwrt.org>
References: <1362255614-30859-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-02 at 21:20 +0100, Felix Fietkau wrote:
> At high data rates the average frame transmission durations are small
> enough for rounding errors to matter, sometimes causing minstrel to use
> slightly lower transmit rates than necessary.
> To fix this, change the unit of the duration value to nanoseconds
> instead of microseconds, and reorder the multiplications/divisions when
> calculating the throughput metric so that they don't overflow or
> truncate prematurely.
> At 2-stream HT40 this makes TCP throughput a bit more stable.

Applied all 3.

johannes

