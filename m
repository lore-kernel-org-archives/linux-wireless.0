Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11186 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbaLHPoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 10:44:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: NF calibration period debugfs file
References: <20141202110443.14817.85639.stgit@potku.adurom.net>
Date: Mon, 8 Dec 2014 17:44:10 +0200
In-Reply-To: <20141202110443.14817.85639.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 2 Dec 2014 13:06:31 +0200")
Message-ID: <87sigqywmt.fsf@kamboji.qca.qualcomm.com> (sfid-20141208_164502_627094_20330A07)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Hi,
>
> here are some changes I made to Peter's NF calibdation period patches. Please
> review.
>
> v2:
>
> * add _MAX define
>
> * support firmware restart
>
> * set cal_period in wmi_tlv_pdev_param_map
>
> * simplify ar->state check
>
> * rename debugfs file to nf_cal_period to not confuse with cal_data
>   file (which is about calibration data)
>
> * WMI_10X_PDEV_PEER_STA_PS_STATECHG_ENABLE -> WMI_10X_PDEV_PARAM_PEER_STA_PS_STATECHG_ENABLE
>
> ---
>
> Peter Oh (2):
>       ath10k: add new pdev parameters for fw 10.2
>       ath10k: add new wmi interface of NF cal period

Both patches applied. Thanks Peter.

-- 
Kalle Valo
