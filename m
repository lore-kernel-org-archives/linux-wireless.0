Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18344 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaLHPeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 10:34:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <devicetree@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<toshik@chromium.org>
Subject: Re: [PATCH v4 0/2] ath10k: device tree support
References: <20141127120727.17546.61202.stgit@potku.adurom.net>
Date: Mon, 8 Dec 2014 17:33:40 +0200
In-Reply-To: <20141127120727.17546.61202.stgit@potku.adurom.net> (Kalle Valo's
	message of "Thu, 27 Nov 2014 14:08:47 +0200")
Message-ID: <878uii17hn.fsf@kamboji.qca.qualcomm.com> (sfid-20141208_163417_707063_2AF920B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> here's providing ath10k calibration data via device tree support which
> Toshi and me have been working on. Please review.
>
> Device tree maintainers: please review the bindings document
> carefully, this is the first time I have written one.
>
> v4:
>
> * use correct devicetree mailing list address
>
> v3:
>
> * add a debug message to ath10k
>
> * write bindings file
>
> * use ar->dev.of_node instead of pci_device_to_OF_node()
>
> v2:
>
> * fixed a bug that returns an uninitialized value if the node is not
>   found
>
> ---
>
> Kalle Valo (1):
>       dt: bindings: add ath10k wireless device
>
> Toshi Kikuchi (1):
>       ath10k: read calibration data from Device Tree

Both patches applied. Thanks Toshi.

-- 
Kalle Valo
