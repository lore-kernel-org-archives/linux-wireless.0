Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34967 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbA2BGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:06:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: implement sta keepalive command
References: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 28 Jan 2015 10:20:43 +0200
In-Reply-To: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 20 Jan 2015 11:23:59 +0100")
Message-ID: <87h9vb9uzo.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_020634_515747_378986FC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> New wmi-tlv firmware for qca6174 has STA keepalive
> service available. The service can provide
> automatic idle connection polling via NullFunc
> frames to AP when acting as a client.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I had a trivial conflict, please check my resolution from the pending
branch:

Applying: ath10k: implement sta keepalive command
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
Auto-merging drivers/net/wireless/ath/ath10k/wmi-ops.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
Failed to merge in the changes.
Patch failed at 0001 ath10k: implement sta keepalive command

-- 
Kalle Valo
