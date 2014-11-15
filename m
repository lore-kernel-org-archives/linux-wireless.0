Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51714 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaKOWqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 17:46:55 -0500
Message-ID: <5467D7D4.6090304@openwrt.org> (sfid-20141115_235032_090180_C414A407)
Date: Sat, 15 Nov 2014 23:46:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: Re: [PATCH 3.18 3/3] ath9k: do not access hardware on IRQs during
 reset
References: <1415900045-49093-1-git-send-email-nbd@openwrt.org> <1415900045-49093-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1415900045-49093-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-13 18:34, Felix Fietkau wrote:
> Instead of killing interrupts during reset when the first one happens,
> kill them before issuing the reset.
> This fixes an easy to reproduce crash with multiple cards sharing the
> same IRQ.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Please disregard this series for now, it seems to be causing some issues
on a few SoC devices.

- Felix
