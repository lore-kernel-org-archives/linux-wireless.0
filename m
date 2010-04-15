Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14789 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab0DOFee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:34:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 22:34:34 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19398.42302.868223.765482@gargle.gargle.HOWL>
Date: Thu, 15 Apr 2010 11:03:50 +0530
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] ath9k_htc: Cleanup beacon configuration
In-Reply-To: <19398.42092.122406.965291@gargle.gargle.HOWL>
References: <19398.42092.122406.965291@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> This patch cleans up beacon configuration,
> removing a redundant interface type check
> and updating beacon interval in the correct place.

John,

This series is on top of Luis' 97-patch series.

Sujith
