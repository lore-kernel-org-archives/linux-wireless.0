Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:35875 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbYB0WBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 17:01:21 -0500
To: linux-wireless@vger.kernel.org
Subject: ath5k on ARM
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 23:01:19 +0100
Message-ID: <m3hcfum53k.fsf@maximus.localdomain> (sfid-20080227_220125_367717_4863473C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Another thing:
ath5k uses udelay(2300). ARM has (include/asm-arm/delay.h):
#define MAX_UDELAY_MS 2

It ends up in __bad_udelay.

Solution?
-- 
Krzysztof Halasa
