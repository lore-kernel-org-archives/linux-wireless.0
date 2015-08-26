Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11550 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbHZJKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 05:10:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <arnd@arndb.de>,
	<linux-wireless@vger.kernel.org>, <twilightrook@gmail.com>,
	<oscarrydberg@gmail.com>, <vvanpo@gmail.com>,
	<joseph.salisbury@canonical.com>
Subject: Re: [PATCH/RFT 1/2] ath10k: add qca6164 support
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
	<1439469147-9408-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Aug 2015 12:09:51 +0300
In-Reply-To: <1439469147-9408-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 13 Aug 2015 14:32:26 +0200")
Message-ID: <87zj1e1km8.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_111007_321528_7C1CB2E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This adds additional 0x0041 PCI Device ID
> definition to ath10k for QCA6164 which is a 1
> spatial stream sibling of the QCA6174 (which is 2
> spatial stream chip).
>
> The QCA6164 needs a dedicated board.bin file which
> is different than the one used for QCA6174. If the
> board.bin is wrong the device will crash early
> while trying to boot firmware. The register dump
> will look like this:
>
>  ath10k_pci 0000:02:00.0: firmware register dump:
>  ath10k_pci 0000:02:00.0: [00]: 0x05010000 0x000015B3 0x000A012D 0x00955B31
>  ...
>
> Note the value 0x000A012D.
>
> Special credit goes to Alan Liu
> <alanliu@qca.qualcomm.com> for providing support
> help which enabled me to come up with this patch.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
