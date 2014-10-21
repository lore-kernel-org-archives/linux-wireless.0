Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15742 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaJUHGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 03:06:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: cal file support
References: <20141013063929.30315.41969.stgit@potku.adurom.net>
Date: Tue, 21 Oct 2014 10:06:14 +0300
In-Reply-To: <20141013063929.30315.41969.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 13 Oct 2014 09:40:40 +0300")
Message-ID: <8738ahzyu1.fsf@kamboji.qca.qualcomm.com> (sfid-20141021_090624_062199_3503794B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> this adds support for loading calibration data from a file as discussed some
> time ago. Please review.
>
> Kalle
>
> ---
>
> Kalle Valo (3):
>       ath10k: add back enum ath10k_bus
>       ath10k: refactor ath10k_init_download_firmware()
>       ath10k: retrieve calibration data from file

All three patches applied.

-- 
Kalle Valo
