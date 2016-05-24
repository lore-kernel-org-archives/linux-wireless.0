Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48667 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbcEXRqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 13:46:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] ath10k: Move rx_location_info out of struct rx_pkt_end
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1461164356-9158-2-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <4f3064b4687744e7bf09e4c8941d117c@euamsexm01a.eu.qualcomm.com> (sfid-20160524_194643_237357_2429FE0B)
Date: Tue, 24 May 2016 19:46:31 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> Define rx_location_info in struct rx_ppdu_end_qca99x0 after
> rx_pkt_end. This is to prepare rx_ppdu_end for QCA9984 chip.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, 4 patches applied to ath.git:

8f09588b2cdc ath10k: move rx_location_info out of struct rx_pkt_end
0fc7e270523b ath10k: clean up growing hw checks during safe and full reset
acc6b5593eee ath10k: define rx_ppdu_end for QCA9984
651b4cdcf97e ath10k: enable support for QCA9984

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8890931/

