Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:44412 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757787AbcCCVOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 16:14:11 -0500
Subject: Re: [PATCH 2/2] mt76: add driver code for MT76x2e
To: linux-wireless@vger.kernel.org
References: <1456941575-99907-1-git-send-email-nbd@openwrt.org>
 <1456941575-99907-2-git-send-email-nbd@openwrt.org>
Cc: kvalo@codeaurora.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D8A91F.8030109@openwrt.org> (sfid-20160303_221417_744400_B4038C54)
Date: Thu, 3 Mar 2016 22:14:07 +0100
MIME-Version: 1.0
In-Reply-To: <1456941575-99907-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-02 18:59, Felix Fietkau wrote:
> This is a 2x2 PCIe 802.11ac chipset by MediaTek
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Found some minor tx queue issues. Will send a v2.

- Felix
