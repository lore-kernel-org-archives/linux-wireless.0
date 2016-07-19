Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50455 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbcGSR6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 13:58:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: simplify the code-paths when not using the built-in
 EEPROM
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160709230955.27266-1-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: <ath9k-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <nbd@nbd.name>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-ID: <cd818a28d787405499102a89d8706ebb@eusanexr01a.eu.qualcomm.com> (sfid-20160719_195858_977035_375A77FC)
Date: Tue, 19 Jul 2016 10:57:34 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:
> There were two paths in the code for "external" eeprom sources. The code
> in eeprom.c only handled the cases where the eeprom data was loaded via
> request_firmware. ahb.c and pci.c on the other hand had some duplicate
> code which was only used when the eeprom data was passed via
> ath9k_platform_data.
> With this change all eeprom data handling is now unified in eeprom.c.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

563985199693 ath9k: simplify the code-paths when not using the built-in EEPROM

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9222187/

