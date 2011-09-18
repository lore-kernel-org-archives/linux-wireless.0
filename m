Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51355 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab1IRJFS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 05:05:18 -0400
Message-ID: <4E75B442.8050806@openwrt.org> (sfid-20110918_110524_307939_E53F0851)
Date: Sun, 18 Sep 2011 11:05:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: use ACCESS_ONCE_RW for write assignments
References: <201109180457.37146.chunkeey@googlemail.com>
In-Reply-To: <201109180457.37146.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-18 4:57 AM, Christian Lamparter wrote:
> This patch fixes a compiler error which was introduced by
> "ath9k_hw: add a new API for setting tx descriptors" [2b63a4].
>
> ar9002_mac.c:185:2: error: assignment of read-only location
> ...
> ar9003_mac.c:37:2: error: assignment of read-only location
> ...
>
> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
When and where was ACCESS_ONCE_RW added? It's not in wireless-testing 
and I can only find references to it on the web in grsecurity patches.

- Felix
