Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31046 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbcCWMIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:08:41 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: add calibration data download support for
 qca4019
Date: Wed, 23 Mar 2016 12:08:36 +0000
Message-ID: <87lh59flbw.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_130845_220001_590869AE)
References: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com>
In-Reply-To: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 10 Mar 2016 15:42:35 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> The necessary update in dt binding doc
> (Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt) is done
> in below patch and it's posted separately,
>   
>   "dt: bindings: add new dt entry for pre calibration in qcom,ath10k.txt"
>
> Raja Mani (3):
>   ath10k: pass cal data location as an argument to
>     ath10k_download_cal_{file|dt}
>   ath10k: move cal data len to hw_params
>   ath10k: incorporate qca4019 cal data download sequence

All three applied, thanks.

-- 
Kalle Valo