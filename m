Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:55759 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1DPIvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2011 04:51:01 -0400
Received: by pxi2 with SMTP id 2so2114724pxi.10
        for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2011 01:51:01 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19881.22790.770806.961386@gargle.gargle.HOWL>
Date: Sat, 16 Apr 2011 14:23:26 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Fix free slot value for cab queue
In-Reply-To: <1302943659-20116-1-git-send-email-rmanoharan@atheros.com>
References: <1302943659-20116-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> ath9k_htc_tx_get_slot can return zero as valid index.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Acked-by: Sujith Manoharan <Sujith.Manoharan@Atheros.com>

Sujith
