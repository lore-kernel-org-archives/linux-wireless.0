Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47961 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760437Ab3JPIwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 04:52:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: rename WMI_CMD_UNDEFINED
References: <1381823732-10128-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 16 Oct 2013 11:52:25 +0300
In-Reply-To: <1381823732-10128-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 15 Oct 2013 09:55:31 +0200")
Message-ID: <871u3l8unq.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_105235_477580_D3D94C60)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Rename WMI_CMD_UNDEFINED to WMI_CMD_UNSUPPORTED. This is more
> accurate here. Also return -EOPNOTSUPP instead of -EINVAL in
> wmi_cmd_send().
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
