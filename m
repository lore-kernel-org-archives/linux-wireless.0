Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53015 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab3AJSi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 13:38:29 -0500
Message-ID: <50EF0A99.6070608@openwrt.org> (sfid-20130110_193843_552453_EADD1F15)
Date: Thu, 10 Jan 2013 19:38:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "ath9k_hw: Fix calibration for AR9340"
References: <1357833830-24005-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1357833830-24005-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-10 5:03 PM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> This reverts commit 03c2dc73581ad4ae54f1ccfc1463929b16b8b736.
> 
> The change for AR9340 breaks TP-Link TL-WDR4300, we can re-submit this
> change once the HW differences are identified and appropriate code
> changes have been made.
> 
> Reported-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
No need to apply this, the root cause has been found and I'll send a fix
for it.

- Felix
