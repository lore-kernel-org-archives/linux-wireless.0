Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64301 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760239Ab3JPIus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 04:50:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: do not warn about unsupported vdev param
References: <1381821980-7966-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 16 Oct 2013 11:50:42 +0300
In-Reply-To: <1381821980-7966-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 15 Oct 2013 09:26:20 +0200")
Message-ID: <8761sx8uql.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_105055_743513_B957AD55)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> 10.X firmware does not support WMI_VDEV_PARAM_TX_ENCAP_TYPE.
> It's a known limitation and we should not warn about this.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
