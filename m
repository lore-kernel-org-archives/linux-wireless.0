Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49578 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbcA1IvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 03:51:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
References: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com>
Date: Thu, 28 Jan 2016 10:51:08 +0200
In-Reply-To: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Wed, 27 Jan 2016 10:55:53 -0800")
Message-ID: <87vb6ekryb.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_095129_779416_693EB136)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Split Mesh service to 11s Mesh and non-11s Mesh according to
> firmware service bit to help users distinguish 11s Mesh from
> non 11s Mesh.
> And add abstraction layer for vdev subtype to solve subtype mismatch
> and to give flexible compatibility among different firmware revisions.
>
> Peter Oh (4):
>   ath10k: rename Mesh related service names
>   ath10k: update 10.4 WMI service map
>   ath10k: use vif->type and vif->p2p for P2P_GO check
>   ath10k: add abstraction layer for vdev subtype

There are conflicts, please rebase.

Applying: ath10k: rename Mesh related service names
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h
Auto-merging drivers/net/wireless/ath/ath10k/mac.c
Failed to merge in the changes.
Patch failed at 0001 ath10k: rename Mesh related service names

-- 
Kalle Valo
