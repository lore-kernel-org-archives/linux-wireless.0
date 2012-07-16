Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57657 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2GPIQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 04:16:33 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20483.52640.521243.418804@gargle.gargle.HOWL> (sfid-20120716_101637_894734_86ACE802)
Date: Mon, 16 Jul 2012 13:45:28 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: "Manoharan, Sujith" <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
In-Reply-To: <5002A7B2.409@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
	<1342105451-42297-2-git-send-email-nbd@openwrt.org>
	<1342105451-42297-3-git-send-email-nbd@openwrt.org>
	<1342105451-42297-4-git-send-email-nbd@openwrt.org>
	<1342105451-42297-5-git-send-email-nbd@openwrt.org>
	<1342105451-42297-6-git-send-email-nbd@openwrt.org>
	<1342105451-42297-7-git-send-email-nbd@openwrt.org>
	<1342105451-42297-8-git-send-email-nbd@openwrt.org>
	<20481.3065.540576.366365@gargle.gargle.HOWL>
	<500143CA.1020804@openwrt.org>
	<506697F5827BD842B7CB80D046EBE618995399@aphydexd01b>
	<5002A7B2.409@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Yes, but ath9k only has global queue settings, not per-vif ones, so I'm
> not sure what can be done about the issue of overwriting queue settings.

Yeah, me neither.

> Either way, it's important for the aggregation limit to be in sync with
> the hardware queue TXOP limit, so I believe this patch is correct.

Except that earlier it was a global, static table. I am curious, which part
of the standard deals with limiting AMPDU size based on txop ? I searched a bit
and got lost.

Sujith
