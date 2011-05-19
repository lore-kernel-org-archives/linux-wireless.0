Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49615 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab1ESJAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 05:00:10 -0400
Message-ID: <4DD4DC13.5020006@openwrt.org> (sfid-20110519_110014_691478_956E5276)
Date: Thu, 19 May 2011 11:00:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: unify edma and non-edma tx code, improve tx
 fifo handling
References: <1305719964-44292-1-git-send-email-nbd@openwrt.org> <20110518190733.GA2543@tuxdriver.com>
In-Reply-To: <20110518190733.GA2543@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-18 9:07 PM, John W. Linville wrote:
>    CC [M]  drivers/net/wireless/ath/ath9k/xmit.o
> drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_edma_tasklet’:
> drivers/net/wireless/ath/ath9k/xmit.c:2199:18: warning: ‘txq’ may be used uninitialized in this function
>
> Please don't add warnings, especially not valid ones... :-)
Odd, I wonder why my compiler didn't show me this warning when I worked 
on the patch, need to check my CFLAGS :)

- Felix
