Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34151 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab3LXLfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 06:35:06 -0500
Message-ID: <52B9715F.8000002@openwrt.org> (sfid-20131224_123519_611007_65CA6033)
Date: Tue, 24 Dec 2013 12:34:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] ath9k: Fix "cc_lock" usage
References: <1387862067-25457-1-git-send-email-sujith@msujith.org> <1387862067-25457-11-git-send-email-sujith@msujith.org>
In-Reply-To: <1387862067-25457-11-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-24 06:14, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> IRQ save/restore is not required for the cycle counters
> since they are accessed only from softirq and process context.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
I think you forgot to remove the now unused 'flags' variable in a few
places.

- Felix
