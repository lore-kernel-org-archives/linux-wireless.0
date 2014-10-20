Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50095 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaJTIsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.49314.54699.154333@gargle.gargle.HOWL> (sfid-20141020_104808_881905_EB67A4A2)
Date: Mon, 20 Oct 2014 13:28:26 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 02/10] ath9k_hw: remove support for UB124 tx gain table
In-Reply-To: <1413651732-69783-2-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
	<1413651732-69783-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> -	else if (AR_SREV_9340(ah))
> -		INIT_INI_ARRAY(&ah->iniModesTxGain,
> -			ar9340Modes_ub124_tx_gain_table_1p0);

Shouldn't the array in ar9340_initvals.h also be removed ?

Sujith
