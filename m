Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50731 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0KTCjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:39:23 -0500
Message-ID: <4CE734D9.90103@openwrt.org>
Date: Sat, 20 Nov 2010 03:39:21 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH 4/4] mac80211: reduce the probe response timeout after
 beacon loss
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org> <1290203740-57124-2-git-send-email-nbd@openwrt.org> <1290203740-57124-3-git-send-email-nbd@openwrt.org> <1290203740-57124-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-4-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-19 10:55 PM, Felix Fietkau wrote:
> Waiting for 500 ms after sending a probe request seems a bit excessive,
> especially when doing 5 attempts. If the connection is bad enough to make
> multiple requests time out, then user space should try to quickly find a
> new AP.
Hmm, don't merge this patch yet, it can cause background scans to
trigger reconnects.

- Felix
