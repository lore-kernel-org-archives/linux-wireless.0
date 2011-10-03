Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12115 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1JCLPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:15:03 -0400
Message-ID: <4E899876.4060103@qca.qualcomm.com> (sfid-20111003_131507_309578_EDD0F8E3)
Date: Mon, 3 Oct 2011 14:11:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 06:01 PM, Vasanthakumar Thiagarajan wrote:
> Packet is not reclaimed when ath6kl_htc_rx_process_hdr() fails.
> Fix this by deferring the packet deletion from comp_pktq till
> ath6kl_htc_rx_process_hdr() returns success.

Does this fix a user visible bug? Or is this just something you found
while doing code review?

Kalle
