Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37009 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014Ab1FWKcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 06:32:22 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] ath9k: Use PS wrappers in beacon tasklet
Date: Thu, 23 Jun 2011 10:30:20 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC88012D5195@nasanexd02b.na.qualcomm.com> (sfid-20110623_123226_814468_0B575DD9)
References: <1308816554-2910-1-git-send-email-rmanoharan@atheros.com>,<1308816554-2910-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1308816554-2910-2-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Ensure that hw is awake before accessing registers during
> beacon generation.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/beacon.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
John,

Please drop this patch as powersave is not supported for ibss/ap mode.

--
Rajkumar

