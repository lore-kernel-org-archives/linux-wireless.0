Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48339 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaJHKYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:24:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix WMI scan command length
References: <1412677603-11748-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 8 Oct 2014 13:24:17 +0300
In-Reply-To: <1412677603-11748-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 7 Oct 2014 12:26:43 +0200")
Message-ID: <87oatmg8q6.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_122451_582589_8C825319)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Fix WMI scan command length we setup when scan request.
>
> This fix issue with 636 firmware when scan always failed
> with message:
>
> ath10k_pci 0000:02:00.0: wmi start scan
> ath10k_pci 0000:02:00.0: wmi stop scan reqid 1 req_type 0 vdev/scan_id 0
> ath10k_pci 0000:02:00.0: failed to stop wmi scan: -11
> ath10k_pci 0000:02:00.0: failed to stop scan: -11
> ath10k_pci 0000:02:00.0: failed to start hw scan: -110
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
