Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30998 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbcEKTxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:53:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: suppress warnings when getting wmi
 peer_rate_code_listevent
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1462536423-9903-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <542b7f110f0b4c74932b60e9276d8a6b@euamsexm01a.eu.qualcomm.com> (sfid-20160511_215353_305447_FB6F760C)
Date: Wed, 11 May 2016 21:53:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> In 10.4, fw sends WMI PEER_RATECODE_LIST_EVENTID after successful
> peer_assoc cmd. As of now this event is not of much use and not
> implemented. Change the debug level and messsage as appropriate
> to suppress "Unknown eventid: 36898".
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, 2 patches applied to ath.git:

36bd39bb0ae8 ath10k: suppress warnings when getting wmi peer_rate_code_list event
ee9ca147c59c ath10k: Fix survey reporting with QCA4019

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9032551/

