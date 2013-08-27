Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55719 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3H0GL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:11:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath10k: CE cleanups
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Aug 2013 09:11:23 +0300
In-Reply-To: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 21 Aug 2013 08:57:23 +0200")
Message-ID: <87a9k3oe7o.fsf@kamboji.qca.qualcomm.com> (sfid-20130827_081132_294158_DEF73DD5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset contains non-functional changes
> except patch #1 which changes memory allocation
> from dynamic to static.

Good cleanups, but there's a problem with long lines:

drivers/net/wireless/ath/ath10k/ce.h:184: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/ce.h:231: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/ce.c:858: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/ce.c:875: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/pci.c:1303: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/pci.c:1304: WARNING: line over 80 characters

> There is still some more to clean up in PCI/CE
> but it's probably better to keep patchsets compact
> and more frequent.

I agree.

-- 
Kalle Valo
