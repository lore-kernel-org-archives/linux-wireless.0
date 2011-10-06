Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32810 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 04:46:41 -0400
Message-ID: <4E8D6AEA.3050708@qca.qualcomm.com> (sfid-20111006_104645_052143_A42EA106)
Date: Thu, 6 Oct 2011 11:46:34 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
References: <1317643087-16104-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317643087-16104-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 02:58 PM, Vasanthakumar Thiagarajan wrote:
> Packet is not reclaimed when ath6kl_htc_rx_process_hdr() fails.
> Fix this by deferring the packet deletion from comp_pktq till
> ath6kl_htc_rx_process_hdr() returns success. This bug is found
> in code review, impact is not easily visible as the leak happens
> only in failure cases.

Thanks, all four applied.

Kalle
