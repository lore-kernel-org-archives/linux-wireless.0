Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25518 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbbK3PPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 10:15:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath10k: print crc32 checksum
References: <20151125133654.25507.10863.stgit@potku.adurom.net>
Date: Mon, 30 Nov 2015 17:15:40 +0200
In-Reply-To: <20151125133654.25507.10863.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 25 Nov 2015 15:37:56 +0200")
Message-ID: <87h9k3ikmb.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_161559_600430_9ADE0BFF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Print crc32 checksum for firmware and board files. Also some improvements how
> we print info messages during boot.
>
> ---
>
> Kalle Valo (6):
>       ath10k: fix otp board id error message
>       ath10k: reorganise hardware and firmware info messages
>       ath10k: always show bmi chip ids and subdevice ids
>       ath10k: split driver info messages during device initialisation
>       ath10k: print crc32 checksums for firmware and board files
>       ath10k: implement fw_checksums debugfs file

All six applied.

-- 
Kalle Valo
