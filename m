Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.45]:20673 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcG0NTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 09:19:05 -0400
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kvalo@qca.qualcomm.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH 0/1 V3] ath9k: consider return code on
 ar9300_eeprom_restore_flash
Message-ID: <27296308-1c21-2eb7-f067-d185fcba48a5@riverbed.com> (sfid-20160727_151912_829557_BE7EFD32)
Date: Wed, 27 Jul 2016 15:19:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kale,

Just added the two error codes you asked:
https://lists.ath9k.org/pipermail/ath9k-devel/2016-July/014686.html

Thanks.

Eduardo Abinader (1):
  ath9k: consider return code on ar9300_eeprom_restore_flash

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.5.0
