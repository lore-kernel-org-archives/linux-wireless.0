Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3LBKwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 05:52:32 -0500
Message-ID: <1385981549.4445.4.camel@jlt4.sipsolutions.net> (sfid-20131202_115236_106487_B41CCBE8)
Subject: Re: [PATCH] nl80211: split 5 and 10 mhz capability flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 11:52:29 +0100
In-Reply-To: <1385414625-53124-1-git-send-email-nbd@openwrt.org>
References: <1385414625-53124-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 22:23 +0100, Felix Fietkau wrote:
> This helps in case we need to support hardware that can only do one of
> the two.

Applied. I also moved the code and squashed this into the right previous
patch ...

johannes

