Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32523 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcCKMRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:17:51 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath5k: fix incorrect indentation
Date: Fri, 11 Mar 2016 12:17:43 +0000
Message-ID: <87ziu5mcnt.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_131807_406092_6ACB16F3)
References: <1456708077-19652-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1456708077-19652-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Sun, 28 Feb 2016 20:07:55 -0500")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> smatch said:
>
> drivers/net/wireless/ath/ath5k/phy.c:1449 ath5k_hw_channel() warn: inconsistent indenting
> drivers/net/wireless/ath/ath5k/reset.c:637 ath5k_hw_on_hold() warn: inconsistent indenting
> drivers/net/wireless/ath/ath5k/reset.c:702 ath5k_hw_nic_wakeup() warn: inconsistent indenting
>
> All of these lines were indented a tabstop too far.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

All three applied to ath.git, thanks.

-- 
Kalle Valo