Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2FOSDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 14:03:55 -0400
Date: Fri, 15 Jun 2012 23:35:09 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH 8/9] ath9k_hw: fix setting lower noise immunity values
Message-ID: <20120615180507.GD648@vmraj-lnx.qca.qualcomm.com> (sfid-20120615_200404_285225_AAF1B089)
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org>
 <1339766727-61926-2-git-send-email-nbd@openwrt.org>
 <1339766727-61926-3-git-send-email-nbd@openwrt.org>
 <1339766727-61926-4-git-send-email-nbd@openwrt.org>
 <1339766727-61926-5-git-send-email-nbd@openwrt.org>
 <1339766727-61926-6-git-send-email-nbd@openwrt.org>
 <1339766727-61926-7-git-send-email-nbd@openwrt.org>
 <1339766727-61926-8-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339766727-61926-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 15, 2012 at 03:25:26PM +0200, Felix Fietkau wrote:
> Commit af1e8a6f "ath9k: reset noiseimmunity level to default" was supposed
> to ensure that the default noise immunity level is above the INI
> values, however it prevents setting lower noise immunity values altogether.
> Fix this by moving the checks to the right function.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ani.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
>
Thanks for the fix.

-Rajkumar
