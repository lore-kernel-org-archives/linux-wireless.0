Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15990 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1I0HVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:21:52 -0400
Message-ID: <4E817989.80603@qca.qualcomm.com> (sfid-20110927_092155_589047_7303FBCD)
Date: Tue, 27 Sep 2011 10:21:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Remove unnecessary retrieval of first list entry
 in ath6kl_htc_tx_setup_scat_list()
References: <1317028743-18092-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317028743-18092-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 12:19 PM, Vasanthakumar Thiagarajan wrote:
> It is unnecessary to take the first list entry from queue again for
> transmission. Sometimes it may look racy when the head of the list
> changes between subsequent retrival, but should not happen in
> practical.

Thanks, applied.

Kalle
