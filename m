Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49759 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbYKCKRI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 05:17:08 -0500
Message-ID: <490ECF97.90601@openwrt.org> (sfid-20081103_111714_427240_B85ADD41)
Date: Mon, 03 Nov 2008 11:16:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: enable RXing beacons
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Prior to this we would rely only on probe responses
> from the AP to keep associated. We now receive beacons
> on ath5k. This should fix sporadic disassociations.
IMHO beacons should be received in AP mode as well, at least
in 11g mode (for automatically enabling protection mode).

- Felix
