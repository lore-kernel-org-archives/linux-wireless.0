Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50201 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab3JJVIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 17:08:30 -0400
Message-ID: <52571744.3040306@openwrt.org> (sfid-20131010_230832_804877_7D49E6CE)
Date: Thu, 10 Oct 2013 23:08:20 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: Re: [PATCH 01/10] ath9k: use a separate data structure for rx buffers
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-10 2:15 PM, Felix Fietkau wrote:
> There's no shared code for handling both rx and tx buffers, and tx
> buffers require a lot more metadata than rx buffers.
> Using a separate data structure for rx reduces memory usage and improves
> cache footprint.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Sorry, this one's missing a chunk. Will send v2.

- Felix

