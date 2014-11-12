Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45735 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaKLL0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 06:26:43 -0500
Message-ID: <546343EF.5090803@openwrt.org> (sfid-20141112_122647_180113_0C39602E)
Date: Wed, 12 Nov 2014 12:26:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 1/6] ath9k: disable overriding AR9340 SLP32 registers
References: <1415689644-29693-1-git-send-email-sujith@msujith.org> <1415689644-29693-2-git-send-email-sujith@msujith.org>
In-Reply-To: <1415689644-29693-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-11 08:07, Sujith Manoharan wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> For AR9340, the correct values for SLP32 registers are present
> in the initvals, so overriding them is not needed.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
What's the point in doing this? The writes don't hurt, and this change
is making the code uglier.

- Felix
