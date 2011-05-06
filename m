Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56698 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab1EFQ4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:56:44 -0400
Message-ID: <4DC42846.3060804@openwrt.org> (sfid-20110506_185654_868453_2C1FC813)
Date: Fri, 06 May 2011 18:56:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: drop an unused column in AR5008-AR9002 initvals
References: <1304697200-42869-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1304697200-42869-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-06 5:53 PM, Felix Fietkau wrote:
> It was used for the defunct 'turbo' mode which was never implemented in the
> driver. Saves ~7.5k uncompressed
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
Don't apply this yet, seems that the tool that generated this still 
needs some fixes. Will send a v2

- Felix
