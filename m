Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1618 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1JCLSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:18:08 -0400
Message-ID: <4E8999E9.4090904@qca.qualcomm.com> (sfid-20111003_131813_537112_B0C697F1)
Date: Mon, 3 Oct 2011 14:18:01 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: Avoid processing failed rx packets
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com> <1317308476-16204-3-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317308476-16204-3-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 06:01 PM, Vasanthakumar Thiagarajan wrote:
> It is not necessary to process an htc_packet which is allocated for rx
> but failed in sdio rx.

Same question here: does it fix a visible bug or is it more like a
theoretical issue?

I would prefer that fixes would also state the impact of the bug: is it
a theoretical issue, a random bug which almost nobody sees or really bad
bug visible almost everywhere? That way it's easier to decide which
trees it should be sent.

Kalle
