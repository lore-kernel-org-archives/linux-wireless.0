Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30271 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbbF3Mc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 08:32:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/10] introduce wmi support for qca99X0
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 30 Jun 2015 15:32:18 +0300
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Mon, 22 Jun 2015 20:10:08 +0530")
Message-ID: <87wpyl1inh.fsf@kamboji.qca.qualcomm.com> (sfid-20150630_143256_119967_823D7F82)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> qca99X0 uses 10.4 firmware. This patch series adds 10.4 firmware
> specific WMI cmds/events/parsing logic. All these patches tested
> on top of qca99X0 initial bring up patches.
>
> v2 changes:
>    - Synced wmi service/cmd/event/pdev/vdev ids to most
>      stable 10.4 firmware.
>
> Raja Mani (10):
>   ath10k: include new wmi op version for 10.4 fw
>   ath10k: add 10.4 fw wmi service bitmap definition
>   ath10k: include 10.4 fw specific wmi cmd and event ids
>   ath10k: set 10.4 fw exclusive wmi cmd as unsupported for other fw
>     versions
>   ath10k: add 10.4 fw wmi vdev cmd ids
>   ath10k: add 10.4 fw wmi pdev cmd ids
>   ath10k: fill 10.4 fw wmi init cmd default values
>   ath10k: handle 10.4 fw wmi mgmt rx event
>   ath10k: adjust default peer limits if qcache enabled in 10.4 fw
>   ath10k: handle 10.4 fw wmi ready event

Thanks, applied.

-- 
Kalle Valo
