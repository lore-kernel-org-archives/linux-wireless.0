Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35115 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab3BVUe5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:34:57 -0500
Message-ID: <5127D66C.7000503@openwrt.org> (sfid-20130222_213500_953436_2F998E3B)
Date: Fri, 22 Feb 2013 21:34:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 3.9] ath9k_htc: fix signal strength handling issues
References: <1361548432-83349-1-git-send-email-nbd@openwrt.org> <20130222200138.GB23235@tuxdriver.com>
In-Reply-To: <20130222200138.GB23235@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-22 9:01 PM, John W. Linville wrote:
>   CC      drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function ‘ath9k_rx_prepare’:
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1071:6: error: implicit declaration of function ‘is_zero_ether_addr’ [-Werror=implicit-function-declaration]
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1072:6: error: implicit declaration of function ‘ether_addr_equal’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
Hm, missing #include. Will send a v2.

Thanks,

- Felix

