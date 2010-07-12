Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47708 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab0GLJUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 05:20:40 -0400
Message-ID: <4C3ADE60.3030309@openwrt.org>
Date: Mon, 12 Jul 2010 11:20:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: Re: [PATCH 7/7] ath9k_hw: handle an rx key miss properly
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org> <1278845325-62000-2-git-send-email-nbd@openwrt.org> <1278845325-62000-3-git-send-email-nbd@openwrt.org> <1278845325-62000-4-git-send-email-nbd@openwrt.org> <1278845325-62000-5-git-send-email-nbd@openwrt.org> <1278845325-62000-6-git-send-email-nbd@openwrt.org> <1278845325-62000-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-7-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-11 12:48 PM, Felix Fietkau wrote:
> If the hardware reports an rx key miss, then the frame has not been
> decrypted at all, and this must be recognized by the software, otherwise
> mac80211 can generate bogus MIC failure events.
> 
> Fix this by reporting an invalid key index if a key miss is detected
> in the rx status.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org
Please ignore this patch, I'll send a v2 of it soon.

- Felix
