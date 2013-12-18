Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39825 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3LRLZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 06:25:39 -0500
Message-ID: <52B18628.1080607@openwrt.org> (sfid-20131218_122542_692276_FDE67A81)
Date: Wed, 18 Dec 2013 12:25:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 07/10] ath9k: Remove ath9k_hw_gettsf32()
References: <1387340607-20045-1-git-send-email-sujith@msujith.org> <1387340607-20045-8-git-send-email-sujith@msujith.org>
In-Reply-To: <1387340607-20045-8-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-18 05:23, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> It is unnecessary and the value is just a simple,
> direct register read.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
I'm using this function in my work-in-progress patches for p2p
multichannel.
Should I switch to using REG_READ in the driver or would you prefer to
drop this patch instead?

- Felix
