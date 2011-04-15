Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38181 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1DOKrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 06:47:49 -0400
Received: by pwi15 with SMTP id 15so1034819pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 03:47:49 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19880.8932.895272.195966@gargle.gargle.HOWL>
Date: Fri, 15 Apr 2011 16:20:12 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 2/2] ath9k_htc: Cleanup HTC debugfs
In-Reply-To: <1302862344-24589-1-git-send-email-rmanoharan@atheros.com>
References: <1302862344-24589-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> Move the ath9k_htc debugfs under ieee80211 to be inline
> with ath9k driver and it also helps to simplify debug code.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Acked-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Sujith
