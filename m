Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3I3JbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:31:15 -0400
Message-ID: <1380533468.14467.5.camel@jlt4.sipsolutions.net> (sfid-20130930_113122_253725_B82B0720)
Subject: Re: [PATCH 3.12 1/2] mac80211: use sta_info_get_bss() for nl80211
 tx and client probing
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 11:31:08 +0200
In-Reply-To: <1380483574-88667-1-git-send-email-nbd@openwrt.org>
References: <1380483574-88667-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-29 at 21:39 +0200, Felix Fietkau wrote:
> This allows calls for clients in AP_VLANs (e.g. for 4-addr) to succeed

Applied.

johannes

