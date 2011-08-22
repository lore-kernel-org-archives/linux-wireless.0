Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42991 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1HVILW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 04:11:22 -0400
To: Bill Jordan <bjordan@rajant.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@openwrt.org
Subject: Re: [PATCH] ath9k: fix MGMT packets when using TKIP
References: <4E4C6258.1030409@openwrt.org>
	<1313766622-15092-1-git-send-email-bjordan@rajant.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 22 Aug 2011 11:11:15 +0300
In-Reply-To: <1313766622-15092-1-git-send-email-bjordan@rajant.com> (Bill Jordan's message of "Fri\, 19 Aug 2011 11\:10\:22 -0400")
Message-ID: <87wre5oogs.fsf@purkki.adurom.net> (sfid-20110822_101127_747223_CAABE1AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bill Jordan <bjordan@rajant.com> writes:

> Prevent 8 bytes from being truncated from MGMT packets
> when using TKIP.

A bit more information in the commit log would be nice. Is this is a
regression or an old bug? Maybe a stable candidate?

-- 
Kalle Valo
