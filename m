Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12584 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1DKQ0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 12:26:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 09:25:50 -0700
From: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Date: Mon, 11 Apr 2011 21:55:02 +0530
Subject: RE: [PATCH 2/2] ath9k: Register id table for platform device
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850EF168C0B@CHEXMB-01.global.atheros.com>
References: <1302520181-11949-1-git-send-email-vasanth@atheros.com>,<1302520181-11949-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302520181-11949-2-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Vasanthakumar Thiagarajan [vasanth@atheros.com]
Sent: Monday, April 11, 2011 4:09 AM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; Gabor Juhos
Subject: [PATCH 2/2] ath9k: Register id table for platform device

Take devid from driver_data of platform_device_id instead of using a hardcoded
value.

Cc: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

Please drop this patch, this would break the existing board support. I'll send an updated one

Vasanth

