Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7842 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRLkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 07:40:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath6kl: fix usb warm reboot and cleanups
References: <20130309100031.432.94974.stgit@localhost6.localdomain6>
Date: Mon, 18 Mar 2013 13:40:12 +0200
In-Reply-To: <20130309100031.432.94974.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sat, 9 Mar 2013 12:01:26 +0200")
Message-ID: <87ppyx7x7n.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_124025_396879_E258446D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> While looking at the usb warm reboot I had to some cleanup, especially with error
> handling.
>
> v2:
>
> o don't remove reset from ath6kl_stop_txrx()
> o line wrap commit logs
>
> ---
>
> Kalle Valo (3):
>       ath6kl: cleanup ath6kl_reset_device()
>       ath6kl: fix usb related error handling and warnings
>       ath6kl: cold reset target after host warm boot

All three patches applied.

-- 
Kalle Valo
