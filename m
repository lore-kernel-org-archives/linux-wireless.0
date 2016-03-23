Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59210 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcCWMHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:07:54 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"robh@kernel.org" <robh@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] dt: bindings: add new dt entry for pre calibration in
 qcom, ath10k.txt
Date: Wed, 23 Mar 2016 12:07:49 +0000
Message-ID: <87poulfld8.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_130800_489066_08DDED48)
References: <1457604724-14378-1-git-send-email-rmani@qti.qualcomm.com>
In-Reply-To: <1457604724-14378-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 10 Mar 2016 15:42:04 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> There two things done in this patch,
>
> 1) Existing device tree entry 'qcom,ath10k-calibration-data' carries
>    not only calibration data, it carries board specific data too.
>    So, make appropriate update in doc.
>
> 2) ipq4019 wifi needs new devie tree entry to carry calibration
>    data alone (called pre cal data, it doesn't include any other info).
>    Using 'qcom,ath10k-calibration-data' for ipq4019 would alter
>    the purpose of it. Hence, add new device tree entry called
>    'qcom,ath10k-pre-calibration-data' to carry only pre calibration data.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo